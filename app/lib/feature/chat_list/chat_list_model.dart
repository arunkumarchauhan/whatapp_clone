import 'dart:async';

import 'package:app/model/resource.dart';
import 'package:app/utils/extensions.dart';
import 'package:app/utils/mapper/qb_message_mapper.dart';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:statemanagement_riverpod/statemanagement_riverpod.dart';

import '../../utils/constants.dart';

class ChatListViewModel extends BasePageViewModel {
  final StreamController<bool> _navigateToDashboardController =
      StreamController();

  final ChatRepository _chatRepository;
  final StorageRepository _storageRepository;
  final AuthRepository _authRepository;

  StreamSubscription? _incomingMessagesSubscription;
  StreamSubscription? _incomingSystemMessagesSubscription;
  StreamSubscription? _connectedChatSubscription;
  late List<QBDialogEntity?> _dialogsList = <QBDialogEntity?>[];

  int? _currentUserId;
  final bool _isNeedUpdateBlocData = true;
  final List<QBDialogEntity> _dialogsToDeleteList = [];
  final PublishSubject<Resource<List<QBDialogEntity?>>>
      _chatListResponseSubject = PublishSubject();
  Stream<Resource<List<QBDialogEntity?>>> get chatListStream =>
      _chatListResponseSubject.stream;

  ChatListViewModel(
      this._authRepository, this._storageRepository, this._chatRepository) {
    _initBlocData();
  }
  void _initBlocData() async {
    await _subscribeConnectedChat();
    _dialogsToDeleteList.clear();
    debugPrint("Connecting Chat : Chat List Model ");
    await _restoreSavedUserId();
    await _connectChat();
    await _subscribeIncomingMessages();
    await _subscribeIncomingSystemMessages();
  }

  Future<void> _subscribeConnectedChat() async {
    if (_connectedChatSubscription != null) {
      return;
    }
    try {
      _connectedChatSubscription = await _chatRepository.subscribeChat();
      _connectedChatSubscription?.onData(_processConnectedChatEvent);
    } catch (e) {
      debugPrint("Exception in _subscribeConnectedChat CHAT LIST VIEW MODEL");
    }
  }

  Future<void> _connectChat() async {
    if (!_isNeedUpdateBlocData) {
      return;
    }

    try {
      final result = await _chatRepository.isConnected();
      bool connected = result.fold((l) => false, (r) => r);
      if (connected) {
        await _updateDialogs();
      } else {
        await _chatRepository.connect(_currentUserId, DEFAULT_USER_PASSWORD);
      }
    } catch (e) {
      debugPrint("_connectChat chat list model exception $e");
    }
  }

  Future<void> _updateDialogs() async {
    final result = await _chatRepository.loadDialogs();
    result.fold((l) => null, (r) {
      _dialogsList = r;
      _chatListResponseSubject.safeAdd(Resource.success(data: _dialogsList));
    });
    for (final element in _dialogsList) {
      try {
        if (element?.type != QBChatDialogTypes.CHAT) {
          final result = await _chatRepository.isJoinedDialog(element?.id);
          bool isJoined = result.fold((l) => false, (r) => r);
          if (!isJoined) {
            await _joinDialog(element?.id);
          }
        }
      } catch (e) {
        _chatListResponseSubject.safeAdd(Resource.error(
            data: null,
            error: AppError(
                throwable: Exception("Update Chat error ChatListModel"),
                error: ErrorInfo(
                    message: "Update Chat error ChatListModel", code: -1),
                type: ErrorType.databaseUserNotFound)));
        debugPrint("Update Chat error ChatListModel $e");
      }
    }
  }

  Future<void> _joinDialog(String? dialogId) async {
    try {
      await _chatRepository.joinDialog(dialogId);
    } catch (e) {
      debugPrint("Exception in _joinDialog Chat List Model");
    }
  }

  void _processConnectedChatEvent(dynamic data) async {
    debugPrint("_processConnectedChatEvent DATA : $data");
    await _updateDialogs();
  }

  Future<void> _subscribeIncomingMessages() async {
    await _unsubscribeIncomingMessages();

    try {
      _incomingMessagesSubscription =
          await _chatRepository.subscribeIncomingMessage();
      _incomingMessagesSubscription?.onData(_processIncomingMessageEvent);
    } catch (exception) {
      debugPrint(
          "Exception _subscribeIncomingMessages Chat List Model $exception");
    }
  }

  Future<void> _processIncomingSystemMessageEvent(dynamic data) async {
    debugPrint("_processIncomingSystemMessageEvent DATA : $data");
    Map<String, Object> map = Map<String, Object>.from(data);
    Map<String?, Object?> payload =
        Map<String?, Object?>.from(map["payload"] as Map<Object?, Object?>);
    Map<String?, Object?> properties = Map<String?, Object?>.from(
        payload["properties"] as Map<Object?, Object?>);

    String? dialogId = payload["dialogId"] as String?;
    int? senderId = payload["senderId"] as int?;
    String? propertyDialogId = properties["dialogId"] as String?;

    if (senderId == _currentUserId) {
      return;
    }

    if (dialogId == "null") {
      // now iOS returns - String "null" in payload["dialogId"]
      dialogId = null;
    }
    dialogId ??= propertyDialogId;

    QBDialogEntity? dialog;
    if (_hasDialog(dialogId!)) {
      print("Dialog List $_dialogsList");
      dialog = _dialogsList.firstWhere((element) =>
          element != null && element.id != null && element.id == dialogId);
    } else {
      final result1 = await _chatRepository.getDialog(dialogId);
      result1.fold((l) => null, (dialog) async {
        if (dialog.type != QBChatDialogTypes.CHAT) {
          final result = await _chatRepository.isJoinedDialog(dialog.id);
          bool isJoined = result.fold((l) => false, (r) => r);
          if (!isJoined) {
            await _joinDialog(dialog.id);
          }
        }
      });
    }
    _dialogsList.remove(dialog);
    _dialogsList.insert(0, dialog);

    _chatListResponseSubject.safeAdd(Resource.success(data: _dialogsList));

    debugPrint(
        "UpdateChatsSuccessState _processIncomingSystemMessageEvent CHAT LIST VIEW MODEL ");
  }

  bool _hasDialog(String dialogId) {
    bool has = false;
    var dialog = _dialogsList.firstWhere(
        (element) =>
            element != null && element.id != null && element.id == dialogId,
        orElse: () => null);
    if (dialog != null) {
      has = true;
    }
    return has;
  }

  void _processIncomingMessageEvent(dynamic data) async {
    debugPrint("_processIncomingMessageEvent DATA : $data");
    Map<String, Object> payload = Map<String, Object>.from(data["payload"]);
    QBMessageEntity? message = QBMessageMapper.mapToQBMessage(payload);
    QBDialogEntity? dialog;
    if (message != null &&
        message.dialogId != null &&
        _hasDialog(message.dialogId!)) {
      Map<String?, Object?> properties = Map<String?, Object?>.from(
          payload["properties"] as Map<Object?, Object?>);
      String? notificationType = properties["notification_type"] as String?;
      if (notificationType ==
              ChatRepositoryConstants.NOTIFICATION_TYPE_LEFT.toString() &&
          message.senderId == _currentUserId) {
        return;
      }
      dialog = _dialogsList.firstWhere((element) =>
          element != null &&
          element.id != null &&
          element.id == message.dialogId);
      dialog?.lastMessage = message.body;
      dialog?.lastMessageDateSent = message.dateSent;
      dialog?.unreadMessagesCount = dialog.unreadMessagesCount ?? 0;
      dialog?.unreadMessagesCount = dialog.unreadMessagesCount! + 1;
      _dialogsList.remove(dialog);
    } else {
      try {
        final result = await _chatRepository.getDialog(message?.dialogId);
        result.fold((l) => null, (r) {
          dialog = r;
        });
      } catch (e) {
        debugPrint(
            "Exception in _processIncomingMessageEvent Chat List Model _processIncomingMessageEvent$e");
      }
    }
    if (dialog != null) {
      _dialogsList.insert(0, dialog);
    }
    _chatListResponseSubject.safeAdd(Resource.success(data: _dialogsList));

    debugPrint("UpdateChatsSuccessState ");
    // states?.add(UpdateChatsSuccessState(_dialogsList));
  }

  Future<void> _subscribeIncomingSystemMessages() async {
    if (_incomingSystemMessagesSubscription == null) {
      try {
        _incomingSystemMessagesSubscription =
            await _chatRepository.subscribeIncomingSystemMessage();
        _incomingMessagesSubscription
            ?.onData(_processIncomingSystemMessageEvent);
      } catch (e) {
        debugPrint("Chat List Model _subscribeIncomingSystemMessages $e");
      }
    }
  }

  Future<void> _unsubscribeIncomingMessages() async {
    await _incomingMessagesSubscription?.cancel();
    _incomingMessagesSubscription = null;
  }

  Future<void> _restoreSavedUserId() async {
    int userId = await _storageRepository.getUserId();
    if (userId != -1) {
      _currentUserId = userId;
    } else {
      debugPrint("Saved User Error ChatListViewModel");
    }
  }

  @override
  void dispose() {
    _chatListResponseSubject.close();

    super.dispose();
  }
}

class ChatRepositoryConstants {
  static const String PROPERTY_DIALOG_ID = "dialog_id";
  static const String PROPERTY_NOTIFICATION_TYPE = "notification_type";
  static const int NOTIFICATION_TYPE_CREATE = 1;
  static const int NOTIFICATION_TYPE_ADD = 2;
  static const int NOTIFICATION_TYPE_LEFT = 3;
}
