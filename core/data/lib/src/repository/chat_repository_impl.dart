import 'dart:async';
import 'dart:collection';

import 'package:data/src/mapper/filter_mapper.dart';
import 'package:data/src/mapper/message_mapper.dart';
import 'package:data/src/mapper/sort_mapper.dart';
import 'package:data/src/mapper/restore/qb_message_mapper.dart';
import 'package:domain/domain.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:data/src/mapper/dialogue_mapper.dart';

class ChatRepositoryImpl implements ChatRepository {
  static const String PROPERTY_DIALOG_ID = "dialog_id";
  static const String PROPERTY_NOTIFICATION_TYPE = "notification_type";
  static const int NOTIFICATION_TYPE_CREATE = 1;
  static const int NOTIFICATION_TYPE_ADD = 2;
  static const int NOTIFICATION_TYPE_LEFT = 3;

  static const String _parameterIsNullException =
      "Required parameters are NULL";

  @override
  Future<Either<NetworkError, bool>> connect(
      int? userId, String password) async {
    try {
      await QB.chat.connect(userId ?? -1, password);
      return Right(true);
    } catch (e) {
      print("Exception in ChatRepositoryImpl connect $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, bool>> disconnect() async {
    try {
      await QB.chat.disconnect();
      return Right(true);
    } catch (e) {
      print("Exception in ChatRepositoryImpl disconnect $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, bool>> isConnected() async {
    try {
      final result = await QB.chat.isConnected();
      if (result != null) {
        return Right(result);
      }
    } catch (e) {
      print("Exception in ChatRepositoryImpl isConnected $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, bool>> pingServer() async {
    try {
      final result = await QB.chat.pingServer();
      return Right(result);
    } catch (e) {
      print("Exception in ChatRepositoryImpl pingServer $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, bool>> pingUser(int userId) async {
    try {
      final result = await QB.chat.pingUser(userId);
      return Right(result);
    } catch (e) {
      print("Exception in ChatRepositoryImpl pingUser $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, List<QBDialogEntity>>> loadDialogs(
      {QBSortEntity? sort,
      QBFilterEntity? filter,
      int? limit,
      int? skip}) async {
    try {
      final result = await QB.chat.getDialogs(
          sort: sort?.restore(),
          filter: filter?.restore(),
          limit: limit,
          skip: skip);

      return Right(result
          .where((element) => element != null)
          .map((e) => e!.transformToDialogueEntity())
          .toList());
    } catch (e) {
      print("Exception in ChatRepositoryImpl loadDialogs $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, QBDialogEntity>> getDialog(
      String? dialogId) async {
    try {
      QBFilter filter = QBFilter();
      filter.field = QBChatDialogFilterFields.ID;
      filter.operator = QBChatDialogFilterOperators.IN;
      filter.value = dialogId;
      List<QBDialog?> dialogList = await QB.chat.getDialogs(filter: filter);
      QBDialog? dialog = dialogList.first;
      if (dialog != null) {
        return Right(dialog.transformToDialogueEntity());
      }
    } catch (e) {
      print("Exception in ChatRepositoryImpl getDialog $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, int>> getDialogsCount(
      QBFilterEntity filter, int limit, int skip) async {
    try {
      final result = await QB.chat.getDialogsCount(
          qbFilter: filter.restore(), limit: limit, skip: skip);
      if (result != null) {
        return Right(result);
      }
    } catch (e) {
      print("Exception in ChatRepositoryImpl getDialogsCount $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, QBDialogEntity>> updateDialog(String? dialogId,
      {List<int>? addUsers, List<int>? removeUsers}) async {
    try {
      final result = await QB.chat.updateDialog(dialogId ?? "",
          addUsers: addUsers, removeUsers: removeUsers);
      if (result != null) {
        return Right(result.transformToDialogueEntity());
      }
    } catch (e) {
      print("Exception in ChatRepositoryImpl updateDialog $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, QBDialogEntity>> createDialog(
      List<int> occupantsIds, String dialogName, int dialogType) async {
    try {
      final result = await QB.chat.createDialog(dialogType,
          dialogName: dialogName, occupantsIds: occupantsIds);
      if (result != null) {
        return Right(result.transformToDialogueEntity());
      }
    } catch (e) {
      print("Exception in ChatRepositoryImpl createDialog $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, bool>> deleteDialog(String? dialogId) async {
    try {
      await QB.chat.deleteDialog(dialogId ?? "");

      return Right(true);
    } catch (e) {
      print("Exception in ChatRepositoryImpl deleteDialog $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, bool>> leaveDialog(String? dialogId) async {
    try {
      await QB.chat.leaveDialog(dialogId ?? "");

      return Right(true);
    } catch (e) {
      print("Exception in ChatRepositoryImpl leaveDialog $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, bool>> joinDialog(String? dialogId) async {
    try {
      await QB.chat.joinDialog(dialogId ?? "");

      return Right(true);
    } catch (e) {
      print("Exception in ChatRepositoryImpl joinDialog $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, List<int>>> getOnlineUsers(
      String? dialogId) async {
    try {
      final result = await QB.chat.getOnlineUsers(dialogId ?? "") as List<int>;

      return Right(result);
    } catch (e) {
      print("Exception in ChatRepositoryImpl getOnlineUsers $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, bool>> sendMessage(
      String? dialogId, String messageBody) async {
    try {
      final result = await QB.chat.sendMessage(dialogId ?? '',
          body: messageBody, saveToHistory: true, markable: true);

      return Right(true);
    } catch (e) {
      print("Exception in ChatRepositoryImpl sendMessage $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, bool>> isJoinedDialog(String? dialogId) async {
    try {
      final result = await QB.chat.isJoinedDialog(dialogId ?? "");

      return Right(result);
    } catch (e) {
      print("Exception in ChatRepositoryImpl isJoinedDialog $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, bool>> sendNotificationMessage(
      String? dialogId, String messageBody, int notificationType) async {
    try {
      Map<String, String> property = HashMap();
      property[PROPERTY_NOTIFICATION_TYPE] = notificationType.toString();
      await QB.chat.sendMessage(dialogId ?? "",
          body: messageBody,
          properties: property,
          markable: true,
          saveToHistory: true);

      return Right(true);
    } catch (e) {
      print("Exception in ChatRepositoryImpl sendNotificationMessage $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, bool>> sendSystemMessage(
      String? dialogId, int? recipientId, int notificationType) async {
    try {
      Map<String, String> property = HashMap();
      property[PROPERTY_NOTIFICATION_TYPE] = notificationType.toString();

      // we need dialog ID in system message. Now we have to pass it in properties
      property[PROPERTY_DIALOG_ID] = dialogId ?? "";
      await QB.chat.sendSystemMessage(recipientId ?? -1, properties: property);

      return Right(true);
    } catch (e) {
      print("Exception in ChatRepositoryImpl sendSystemMessage $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, bool>> markMessageRead(
      QBMessageEntity message) async {
    try {
      await QB.chat.markMessageRead(message.restore());

      return Right(true);
    } catch (e) {
      print("Exception in ChatRepositoryImpl markMessageRead $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, bool>> markMessageDelivered(
      QBMessageEntity message) async {
    try {
      await QB.chat.markMessageDelivered(message.restore());

      return Right(true);
    } catch (e) {
      print("Exception in ChatRepositoryImpl markMessageDelivered $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, bool>> sendIsTyping(String? dialogId) async {
    try {
      await QB.chat.sendIsTyping(dialogId ?? "");
      return Right(true);
    } catch (e) {
      print("Exception in ChatRepositoryImpl markMessageDelivered $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, bool>> sendStoppedTyping(String? dialogId) async {
    try {
      await QB.chat.sendStoppedTyping(dialogId ?? "");
      return Right(true);
    } catch (e) {
      print("Exception in ChatRepositoryImpl markMessageDelivered $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, List<QBMessageEntity>>>
      getDialogMessagesByDateSent(String? dialogId,
          {int limit = 100, int skip = 0}) async {
    try {
      QBSort sort = QBSort();
      sort.field = QBChatMessageSorts.DATE_SENT;
      sort.ascending = false;

      final result = await QB.chat.getDialogMessages(dialogId ?? "",
          sort: sort, limit: limit, skip: skip, markAsRead: false);

      // List<QBMessageEntity> test = [];
      // for (var t in result) {
      //   if (t != null) {
      //     test.add(QBMessageEntity(id: t.id));
      //   }
      // }
      // return Right(test);
      return Right(result
          .where((element) => element != null)
          .map((e) => e!.transform())
          .toList());
    } catch (e) {
      print("Exception in ChatRepositoryImpl getDialogMessagesByDateSent $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, QBMessageEntity>> getMessageById(
      String? dialogId, String? messageId) async {
    try {
      QBFilter filter = QBFilter();
      filter.field = QBChatMessageFilterFields.ID;
      filter.value = messageId;
      filter.operator = QBChatMessageFilterOperators.IN;

      List<QBMessage?> messageList =
          await QB.chat.getDialogMessages(dialogId ?? "", filter: filter);
      QBMessage? message = messageList.first;
      if (message != null) {
        return Right(message.transform());
      }
    } catch (e) {
      print("Exception in ChatRepositoryImpl getMessageById $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<StreamSubscription<dynamic>> subscribeChat() async {
    print("DATa LAYER subscribeChat called");
    await QB.settings.enableAutoReconnect(true);
    return QB.chat.subscribeChatEvent(QBChatEvents.CONNECTED, (data) {
      print("subscribeChat data repo impl $data");
    }, onErrorMethod: (error) {
      print("Error DATA LAyer subscribeChat $error ");
    });
  }

  @override
  Future<StreamSubscription<dynamic>> subscribeIncomingMessage() async {
    print("DATa LAYER subscribeIncomingMessage called");

    return QB.chat.subscribeChatEvent(QBChatEvents.RECEIVED_NEW_MESSAGE,
        (data) {
      print("DATA LAYER subscribeIncomingMessage data $data");
    }, onErrorMethod: (error) {
      print("DATA LAYER subscribeIncomingMessage Error $error");
    });
  }

  @override
  Future<StreamSubscription<dynamic>> subscribeIncomingSystemMessage() async {
    await QB.settings.enableAutoReconnect(true);
    final result = await QB.chat
        .subscribeChatEvent(QBChatEvents.RECEIVED_SYSTEM_MESSAGE, (data) {
      print("Data Layerr subscribeIncomingSystemMessage $data");
    }, onErrorMethod: (error) {
      print("Data Layer subscribeIncomingSystemMessage error $error");
    });
    print("subscribeIncomingSystemMessage Stream Channel found $result");
    return result;
  }

  @override
  Future<StreamSubscription<dynamic>> subscribeMessageRead() async {
    await QB.settings.enableAutoReconnect(true);
    return QB.chat.subscribeChatEvent(QBChatEvents.MESSAGE_READ, (data) {
      print("Data layer subscribeMessageRead Data $data");
    }, onErrorMethod: (error) {
      print("Data layer subscribeMessageRead Error $error");
    });
  }

  @override
  Future<StreamSubscription<dynamic>> subscribeMessageDelievered() async {
    await QB.settings.enableAutoReconnect(true);
    return QB.chat
        .subscribeChatEvent(QBChatEvents.MESSAGE_DELIVERED, (data) {});
  }

  @override
  Future<StreamSubscription<dynamic>> subscribeUserIsTyping() async {
    await QB.settings.enableAutoReconnect(true);
    return QB.chat.subscribeChatEvent(QBChatEvents.USER_IS_TYPING, (data) {});
  }

  @override
  Future<StreamSubscription<dynamic>> subscribeUserStoppedTyping() async {
    await QB.settings.enableAutoReconnect(true);
    return QB.chat
        .subscribeChatEvent(QBChatEvents.USER_STOPPED_TYPING, (data) {});
  }
}
