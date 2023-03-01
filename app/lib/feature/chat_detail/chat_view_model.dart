import 'dart:async';
import 'dart:math';

import 'package:app/feature/chat_detail/chat_detail_page.dart';
import 'package:app/feature/chat_list/chat_list_model.dart';
import 'package:app/model/qb_message_wrapper.dart';
import 'package:app/model/resource.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/extensions.dart';
import 'package:app/utils/mapper/qb_message_mapper.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:statemanagement_riverpod/statemanagement_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class ChatDetailViewModel extends BasePageViewModel {
  final ChatRepository _chatRepository;
  final QBUserRepository _usersRepository;
  final StorageRepository _storageRepository;

  TextEditingController messageController = TextEditingController();
  BehaviorSubject<bool> toggleEmojiKeyboard = BehaviorSubject.seeded(false);
  final PublishSubject<Resource<List<QBMessageWrapper>>>
      _messageResponseSubject = PublishSubject();
  Stream<Resource<List<QBMessageWrapper>>> get messageStream =>
      _messageResponseSubject.stream;
  FocusNode focusNode = FocusNode();
  ChatDetailPageArgs args;

  static const int PAGE_SIZE = 20;
  static const int TEXT_MESSAGE_MAX_SIZE = 1000;

  int? _localUserId;
  String? _dialogId;
  QBDialogEntity? _dialog;
  bool _isNewChat = false;
  final TypingStatusTimer _typingStatusTimer = TypingStatusTimer();
  final Map<int, QBUserEntity> _participantsMap = <int, QBUserEntity>{};
  final Set<QBMessageWrapper> _wrappedMessageSet = <QBMessageWrapper>{};
  final List<String> _typingUsersNames = <String>[];

  StreamSubscription? _incomingMessagesSubscription;
  StreamSubscription? _connectedChatSubscription;
  StreamSubscription? _typingSubscription;
  StreamSubscription? _stopTypingSubscription;
  StreamSubscription? _messageReadSubscription;
  StreamSubscription? _messageDeliveredSubscription;
  ChatDetailViewModel(this.args, this._chatRepository, this._storageRepository,
      this._usersRepository) {
    print("Args : $args");
    focusNode.unfocus();
    _dialogId = args.dialogueId;
    _isNewChat = false;
    _initBlocData();
  }

  Future<void> _initBlocData() async {
    debugPrint("Init Bloc Called");
    await _restoreSavedUserId();
    await _subscribeConnectedChat();

    // states?.add(ChatConnectingState());
    await _connectChat();
    await _subscribeEvents();
    debugPrint("Init Excetution Started");
  }

  void onConnectedChat() async {
    await _initBlocData();
  }

  void loadNextMessage() async {
    try {
      await _loadMessages();
    } catch (e) {
      //states?.add(LoadNextMessagesErrorState(makeErrorMessage(e)));
    }
  }

  Future<void> updateChat() async {
    try {
      _wrappedMessageSet.clear();
      await _updateDialog();
      await _loadMessages();
    } catch (e) {
      loadingSubject.add(false);
      debugPrint("Update Chat Event Exception $e");
    }
  }

  Future<void> sendMessage() async {
    String trimmedMessage = messageController.text.trim();
    if (trimmedMessage.isEmpty) {
      return;
    }
    try {
      await _chatRepository.sendStoppedTyping(_dialogId);
      await Future.delayed(const Duration(milliseconds: 300), () async {
        await _sendTextMessage(trimmedMessage);
        print("Mesage Sent");
        messageController.text = "";
      });
    } catch (e) {
      debugPrint("Send Message Exception $e");
      // states?.add(SendMessageErrorState(
      //     makeErrorMessage(e), receivedEvent.textMessage));
    }
  }

  Future<void> markMessageRead() async {
//    receivedEvent.message
    _chatRepository.markMessageRead(QBMessageEntity());
  }

  Future<void> sendStartTyping() async {
    try {
      await _chatRepository.sendIsTyping(_dialogId);
    } catch (e) {
      debugPrint("Exception sendStartTyping $e");
      //states?.add(ErrorState(e.message));
    }
  }

  Future<void> sendStopTyping() async {
    try {
      await _chatRepository.sendStoppedTyping(_dialogId);
    } catch (e) {
      debugPrint("Exception sendStopTyping $e");
      //states?.add(ErrorState(e.message));
    }
  }

  sendUserAddedEvent() async {
    List<int>? addedUsersIds = [];
    if (addedUsersIds.contains(-1)) {
      return;
    }
    try {
      _chatRepository
          .updateDialog(_dialogId, addUsers: addedUsersIds)
          .then((dialog) {
        dialog.fold((l) => null, (r) {
          _dialog = r;
        });

        _usersRepository.getUsersByIds(addedUsersIds).then((result) {
          List<QBUserEntity?> addedUsers = [];
          result.fold((l) => null, (r) {
            addedUsers = r;
          });
          _sendNotificationMessageAddedUsers(addedUsers);
          _sendSystemMessagesAddedUsers(_dialog?.occupantsIds); // to occupants
        });
      });
    } catch (e) {
      debugPrint("ErrorState sendUserAddedEvent $e");
      //states?.add(ErrorState(e.message));
    }
  }

  Future<void> returnChatScreenEvent() async {
    await _initBlocData();
  }

  Future<void> leaveChatEvent() async {
    try {
      // states?.add(LoadMessagesInProgressState());
      await _sendNotificationMessageLeftChat();
      await _leaveChat();
      await _sendSystemMessagesLeftChat();
      await _unsubscribeEvents();
      //states?.add(ReturnToDialogsState());
    } catch (e) {
      debugPrint("Exception leaveChatEvent $e");
      //states?.add(LeaveChatErrorState(makeErrorMessage(e)));
    }
  }

  Future<void> deleteChatEvent() async {
    try {
      await _chatRepository.deleteDialog(_dialogId);
    } catch (e) {
      debugPrint("Exception deleteChatEvent $e");
    }
  }

  Future<void> onReceiveEvent() async {}

  Future<void> _unsubscribeEvents() async {
    await _unsubscribeIncomingMessages();
    await _unsubscribeMessageStatuses();
    await _unsubscribeTypingStatus();
  }

  Future<void> _subscribeEvents() async {
    await _subscribeTypingStatus();
    await _subscribeIncomingMessages();
    await _subscribeDeliveredStatus();
    await _subscribeReadStatus();
  }

  Future<void> _sendNotificationMessageCreatedChat() async {
    if (_dialog == null || _dialog!.name == null) {
      //states?.add(ErrorState("Dialog is null"));
    }
    String userName = await _storageRepository.getUserFullName();
    String messageBody = '$userName created the group chat "${_dialog!.name}"';
    await _chatRepository.sendNotificationMessage(_dialogId, messageBody,
        ChatRepositoryConstants.NOTIFICATION_TYPE_CREATE);
  }

  void _sendSystemMessagesCreatedChat() async {
    _dialog?.occupantsIds?.forEach((occupantId) async {
      if (occupantId == _localUserId) {
        return;
      }
      await Future.delayed(const Duration(milliseconds: 200), () {
        _chatRepository.sendSystemMessage(_dialogId, occupantId,
            ChatRepositoryConstants.NOTIFICATION_TYPE_CREATE);
      });
    });
  }

  void _sendNotificationMessageAddedUsers(List<QBUserEntity?> users) async {
    List<String?> namesList = [];
    for (var element in users) {
      namesList.add(element?.fullName ?? element?.login);
    }
    String usersNames = namesList.join(', ');
    String userName = await _storageRepository.getUserFullName();
    String messageBody = '$userName added $usersNames';
    _chatRepository.sendNotificationMessage(
        _dialogId, messageBody, ChatRepositoryConstants.NOTIFICATION_TYPE_ADD);
  }

  void _sendSystemMessagesAddedUsers(List<int>? ids) {
    for (int id in ids!) {
      _chatRepository.sendSystemMessage(
          _dialogId, id, ChatRepositoryConstants.NOTIFICATION_TYPE_ADD);
    }
  }

  Future<void> _sendNotificationMessageLeftChat() async {
    String messageBody =
        "${await _storageRepository.getUserFullName()} has left";
    await _chatRepository.sendNotificationMessage(
        _dialogId, messageBody, ChatRepositoryConstants.NOTIFICATION_TYPE_LEFT);
  }

  Future<void> _sendSystemMessagesLeftChat() async {
    _dialog?.occupantsIds?.forEach((occupantId) async {
      if (occupantId != _localUserId) {
        await Future.delayed(const Duration(milliseconds: 200), () {
          _chatRepository.sendSystemMessage(_dialogId, occupantId,
              ChatRepositoryConstants.NOTIFICATION_TYPE_LEFT);
        });
      }
    });
  }

  Future<void> _leaveChat() async {
    if (_localUserId == null || _dialogId == null) {
      //states?.add(ErrorState("UserId or DialogId is null"));
      debugPrint("_leaveChat ErrorState UserId or DialogId is null");
      return;
    }
    await _chatRepository.leaveDialog(_dialogId);
    await _chatRepository.updateDialog(_dialogId, removeUsers: [_localUserId!]);
  }

  List<QBMessageWrapper> _getMessageListSortedByDate() {
    List<QBMessageWrapper> list = _wrappedMessageSet.toList();
    list.sort((first, second) => first.date.compareTo(second.date));
    return list;
  }

  Future<void> _subscribeReadStatus() async {
    await _messageReadSubscription?.cancel();
    _messageReadSubscription = null;

    try {
      // _messageReadSubscription = await QB.chat.subscribeChatEvent(
      //     QBChatEvents.MESSAGE_READ, _processMessageReadEvent);
      _messageReadSubscription = await _chatRepository.subscribeMessageRead();
      _messageReadSubscription?.onData(_processMessageReadEvent);
    } catch (e) {
      // states?.add(ErrorState(makeErrorMessage(e)));
    }
  }

  void _processMessageReadEvent(dynamic data) {
    Map<dynamic, dynamic> messageStatusHashMap = data;
    Map<String, Object> payloadMap =
        Map<String, Object>.from(messageStatusHashMap["payload"]);

    String? dialogId = payloadMap["dialogId"] as String;
    String? messageId = payloadMap["messageId"] as String;
    int? userId = payloadMap["userId"] as int;

    if (_dialogId == dialogId) {
      for (QBMessageWrapper message in _wrappedMessageSet) {
        if (message.id == messageId) {
          message.qbMessage.readIds?.add(userId);
          break;
        }
      }
      _messageResponseSubject
          .safeAdd(Resource.success(data: _getMessageListSortedByDate()));
      loadingSubject.add(false);
      // states
      //     ?.add(LoadMessagesSuccessState(_getMessageListSortedByDate(), true));
    }
  }

  Future<void> _subscribeDeliveredStatus() async {
    await _messageDeliveredSubscription?.cancel();
    _messageDeliveredSubscription = null;

    try {
      _messageDeliveredSubscription =
          await _chatRepository.subscribeMessageDelievered();
      _messageDeliveredSubscription?.onData(_processMessageDeliveredEvent);
    } catch (e) {
      debugPrint("Exception in _subscribeDeliveredStatus $e");
      // states?.add(ErrorState(makeErrorMessage(e)));
    }
  }

  void _processMessageDeliveredEvent(dynamic data) {
    Map<dynamic, dynamic> messageStatusMap = data;
    Map<String, Object> payloadMap =
        Map<String, Object>.from(messageStatusMap["payload"]);

    String? dialogId = payloadMap["dialogId"] as String;
    String? messageId = payloadMap["messageId"] as String;
    int? userId = payloadMap["userId"] as int;

    if (_dialogId == dialogId) {
      for (QBMessageWrapper message in _wrappedMessageSet) {
        if (message.id == messageId) {
          message.qbMessage.deliveredIds?.add(userId);
          break;
        }
      }
      Resource.success(data: _getMessageListSortedByDate());
      loadingSubject.add(false);
      // states
      //     ?.add(LoadMessagesSuccessState(_getMessageListSortedByDate(), true));
    }
  }

  Future<void> _subscribeIncomingMessages() async {
    await _unsubscribeIncomingMessages();

    try {
      // _incomingMessagesSubscription = await QB.chat.subscribeChatEvent(
      //     QBChatEvents.RECEIVED_NEW_MESSAGE, _processIncomingMessageEvent);

      _incomingMessagesSubscription =
          await _chatRepository.subscribeIncomingMessage();

      _incomingMessagesSubscription!.onData(_processIncomingMessageEvent);
      _incomingMessagesSubscription!.onError((error) {
        debugPrint("_incomingMessagesSubscription error $error");
      });
      debugPrint("inside _subscribeIncomingMessages");
    } catch (e) {
      debugPrint(
          "ErrorState in _subscribeIncomingMessages chat detail View Model $e");
      //  states?.add(ErrorState(makeErrorMessage(e)));
    }
  }

  void _processIncomingMessageEvent(dynamic data) async {
    debugPrint("INSIDE _processIncomingMessageEvent");
    print("Message is $data");
    Map<String, Object> map = Map<String, Object>.from(data);
    Map<String?, Object?> payload =
        Map<String?, Object?>.from(map["payload"] as Map<Object?, Object?>);

    String? dialogId = payload["dialogId"] as String;
    if (dialogId == _dialogId) {
      QBMessageEntity? message = QBMessageMapper.mapToQBMessage(payload);
      _wrappedMessageSet.addAll(await _wrapMessages([message]));

      _messageResponseSubject
          .safeAdd(Resource.success(data: _getMessageListSortedByDate()));
      // states
      //     ?.add(LoadMessagesSuccessState(_getMessageListSortedByDate(), true));
    }
  }

  Future<void> _subscribeConnectedChat() async {
    if (_connectedChatSubscription != null) {
      print("Inside _subscribeConnectedChat Not null");

      return;
    }

    try {
      _connectedChatSubscription = await _chatRepository.subscribeChat();
      _connectedChatSubscription!.onData(_processConnectedChatEvent);
      _connectedChatSubscription!.onError((error) {
        debugPrint("Error Occured in _subscribeConnectedChat");
      });
    } catch (e) {
      debugPrint("ErrorState Chat View Model _subscribeConnectedChat $e");
      // states?.add(ErrorState(makeErrorMessage(e)));
    }
  }

  void _processConnectedChatEvent(dynamic data) async {
    // states?.add(ChatConnectedState(_localUserId!));
    debugPrint("Inside _processConnectedChatEvent");
    updateChat();
    debugPrint("ChateConnectedState");
  }

  Future<void> _unsubscribeConnectedChat() async {
    await _connectedChatSubscription?.cancel();
    _connectedChatSubscription = null;
  }

  Future<void> _unsubscribeMessageStatuses() async {
    await _messageDeliveredSubscription?.cancel();
    _messageDeliveredSubscription = null;

    await _messageReadSubscription?.cancel();
    _messageReadSubscription = null;
  }

  Future<void> _unsubscribeIncomingMessages() async {
    await _incomingMessagesSubscription?.cancel();
    _incomingMessagesSubscription = null;
  }

  Future<void> _restoreSavedUserId() async {
    int userId = await _storageRepository.getUserId();
    if (userId != -1) {
      _localUserId = userId;
    } else {
      // states?.add(SavedUserErrorState());
      debugPrint("CHat Detail View model SavedUserErrorState $e");
    }
  }

  Future<void> _connectChat() async {
    if (_localUserId == null) {
      // states?.add(ChatConnectingErrorState("UserId is null"));
    }
    try {
      bool connected =
          (await _chatRepository.isConnected()).fold((l) => false, (r) => r);
      if (connected) {
        // states?.add(ChatConnectedState(_localUserId!));
      } else {
        _chatRepository.connect(_localUserId, DEFAULT_USER_PASSWORD);
      }
    } catch (e) {
      debugPrint(
          "ChatConnectingErrorState _connectChat CHAT DETAIL VIEW MODEL $e");
      //   states?.add(ChatConnectingErrorState(makeErrorMessage(e)));
    }
  }

  Future<void> _updateDialog() async {
    //  states?.add(UpdateChatInProgressState());
    try {
      (await _chatRepository.getDialog(_dialogId)).fold((l) {
        _dialog = null;
      }, (r) {
        _dialog = r;
      });

      if (_dialog == null) {
        return;
      }

      // states?.add(UpdateChatSuccessState(_dialog!));
      if (_dialog?.type != QBChatDialogTypes.CHAT) {
        bool isJoined = (await _chatRepository.isJoinedDialog(_dialogId))
            .fold((l) => false, (r) => r);
        if (!isJoined) {
          await _chatRepository.joinDialog(_dialogId);
        }
      }
      if (_isNewChat && _dialog?.type == QBChatDialogTypes.GROUP_CHAT) {
        await _sendNotificationMessageCreatedChat()
            .then((_) => _sendSystemMessagesCreatedChat());
        _isNewChat = false;
      }
    } catch (e) {
      debugPrint(
          "UpdateChatErrorState _updateDialog CHAT DETAIL VIEW MODEL $e");
      //states?.add(UpdateChatErrorState(makeErrorMessage(e)));
    }
  }

  Future<void> _loadMessages() async {
    int skip = 0;
    if (_wrappedMessageSet.isNotEmpty) {
      skip = _wrappedMessageSet.length;
    }

    // states?.add(LoadMessagesInProgressState());
    _messageResponseSubject.safeAdd(Resource.loading());
    List<QBMessageEntity> messages = [];
    try {
      final result = await _chatRepository
          .getDialogMessagesByDateSent(_dialogId, limit: PAGE_SIZE, skip: skip);
      result.fold((l) => null, (r) {
        messages = r;
      });
    } catch (e) {
      debugPrint("UpdateChatErrorState CHAT DETAIL VIEW MODEL _loadMessages$e");
      //states?.add(UpdateChatErrorState(makeErrorMessage(e)));
    }

    if (messages != null || _localUserId != null) {
      _loadUsers(messages);
      List<QBMessageWrapper> wrappedMessages = await _wrapMessages(messages);

      _wrappedMessageSet.addAll(wrappedMessages);
      bool hasMore = messages.length == PAGE_SIZE;

      if (skip == 0) {
        await _subscribeEvents();
      }
      loadingSubject.add(false);
      _messageResponseSubject
          .safeAdd(Resource.success(data: _getMessageListSortedByDate()));

      // states?.add(
      //     LoadMessagesSuccessState(_getMessageListSortedByDate(), hasMore));
    }
  }

  void _loadUsers(List<QBMessageEntity?> messages) async {
    if (messages.isEmpty) {
      return;
    }

    Set<int> usersIds = <int>{};
    if (_localUserId != null) {
      usersIds.add(_localUserId!);
    }
    for (var message in messages) {
      if (message != null && message.senderId != null) {
        usersIds.add(message.senderId!);
      }
    }

    List<QBUserEntity?> users = [];
    final result = await _usersRepository.getUsersByIds(usersIds.toList());
    result.fold((l) => null, (r) {
      users = r;
    });
    if (users.isNotEmpty) {
      _saveParticipants(users);
    }
  }

  Future<void> _sendTextMessage(String text) async {
    if (text.length > TEXT_MESSAGE_MAX_SIZE) {
      text = text.substring(0, TEXT_MESSAGE_MAX_SIZE);
    }
    print("Dialogue ID $_dialogId");
    await _chatRepository.sendMessage(_dialogId, text);
  }

  Future<List<QBMessageWrapper>> _wrapMessages(
      List<QBMessageEntity?> messages) async {
    List<QBMessageWrapper> wrappedMessages = [];
    for (QBMessageEntity? message in messages) {
      if (message == null) {
        break;
      }

      QBUserEntity? sender = _getParticipantById(message.senderId);
      if (sender == null && message.senderId != null) {
        List<QBUserEntity?> users = [];
        final result =
            await _usersRepository.getUsersByIds([message.senderId!]);
        result.fold((l) => null, (r) {
          users = r;
        });
        if (users.isNotEmpty) {
          sender = users[0];
          _saveParticipants(users);
        }
      }
      String senderName = sender?.fullName ?? sender?.login ?? "DELETED User";
      wrappedMessages.add(QBMessageWrapper(senderName, message, _localUserId!));
    }
    return wrappedMessages;
  }

  Future<void> _subscribeTypingStatus() async {
    await _unsubscribeTypingStatus();

    try {
      // _typingSubscription = await QB.chat.subscribeChatEvent(
      //     QBChatEvents.USER_IS_TYPING, _processIsTypingEvent);
      _typingSubscription = await _chatRepository.subscribeUserIsTyping();
      _typingSubscription?.onData(_processIsTypingEvent);
    } catch (e) {
      debugPrint("_subscribeTypingStatus CHAT DETAIL VIEW MODEL 1 $e");
      //  states?.add(ErrorState(makeErrorMessage(e)));
    }

    try {
      // _stopTypingSubscription = await QB.chat.subscribeChatEvent(
      //     QBChatEvents.USER_STOPPED_TYPING, _processStopTypingEvent);
      _stopTypingSubscription =
          await _chatRepository.subscribeUserStoppedTyping();
      _stopTypingSubscription?.onData(_processStopTypingEvent);
    } catch (e) {
      debugPrint("_subscribeTypingStatus CHAT DETAIL VIEW MODEL 2 $e");
      //states?.add(ErrorState(makeErrorMessage(e)));
    }
  }

  Future<void> _unsubscribeTypingStatus() async {
    await _typingSubscription?.cancel();
    _typingSubscription = null;

    await _stopTypingSubscription?.cancel();
    _stopTypingSubscription = null;
  }

  void _processIsTypingEvent(dynamic data) async {
    Map<String, Object> map = Map<String, Object>.from(data);
    Map<String?, Object?> payload =
        Map<String?, Object?>.from(map["payload"] as Map<Object?, Object?>);

    String dialogId = payload["dialogId"] as String;
    int userId = payload["userId"] as int;

    if (userId == _localUserId) {
      return;
    }
    if (dialogId == _dialogId) {
      var user = _getParticipantById(userId);
      if (user == null) {
        List<QBUserEntity?> users = [];
        final result = await _usersRepository.getUsersByIds([userId]);
        result.fold((l) => null, (r) {
          users = r;
        });
        if (users.isNotEmpty) {
          _saveParticipants(users);
          user = users[0];
        }
      }

      String? userName = user?.fullName ?? user?.login;
      if (userName == null || userName.isEmpty) {
        userName = "Unknown";
      }
      _typingUsersNames.remove(userName);
      _typingUsersNames.insert(0, userName);
      //  states?.add(OpponentIsTypingState(_typingUsersNames));
      _typingStatusTimer.cancelWithDelay(() {
        // states?.add(OpponentStoppedTypingState());
        _typingUsersNames.remove(userName);
      });
    }
  }

  void _processStopTypingEvent(dynamic data) {
    Map<String, Object> map = Map<String, Object>.from(data);
    Map<String?, Object?> payload =
        Map<String?, Object?>.from(map["payload"] as Map<Object?, Object?>);

    String dialogId = payload["dialogId"] as String;
    int userId = payload["userId"] as int;

    if (dialogId == _dialogId) {
      var user = _getParticipantById(userId);
      var userName = user?.fullName ?? user?.login;

      _typingUsersNames.remove(userName);
      if (_typingUsersNames.isEmpty) {
        // states?.add(OpponentStoppedTypingState());
      } else {
        //  states?.add(OpponentIsTypingState(_typingUsersNames));
      }
    }
  }

  void _saveParticipants(List<QBUserEntity?> users) {
    for (QBUserEntity? user in users) {
      if (user?.id != null) {
        if (_participantsMap.containsKey(user?.id)) {
          _participantsMap.update(user!.id!, (value) => user);
        } else {
          _participantsMap[user!.id!] = user;
        }
      }
    }
  }

  QBUserEntity? _getParticipantById(int? userId) {
    return _participantsMap.containsKey(userId)
        ? _participantsMap[userId]
        : null;
  }
}

class TypingStatusTimer {
  static const int TIMER_DELAY = 30;
  Timer? _timer;

  cancelWithDelay(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: TIMER_DELAY), callback);
  }

  cancel() {
    _timer?.cancel();
  }
}
