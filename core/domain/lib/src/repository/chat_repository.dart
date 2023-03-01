import 'dart:async';

import '../../domain.dart';

abstract class ChatRepository {
  Future<Either<NetworkError, bool>> connect(int? userId, String password);

  Future<Either<NetworkError, bool>> disconnect();

  Future<Either<NetworkError, bool>> isConnected();

  Future<Either<NetworkError, bool>> pingServer();

  Future<Either<NetworkError, bool>> pingUser(int userId);

  Future<Either<NetworkError, List<QBDialogEntity>>> loadDialogs(
      {QBSortEntity? sort, QBFilterEntity? filter, int? limit, int? skip});

  Future<Either<NetworkError, QBDialogEntity>> getDialog(String? dialogId);

  Future<Either<NetworkError, int>> getDialogsCount(
      QBFilterEntity filter, int limit, int skip);

  Future<Either<NetworkError, QBDialogEntity>> updateDialog(String? dialogId,
      {List<int>? addUsers, List<int>? removeUsers});

  Future<Either<NetworkError, QBDialogEntity>> createDialog(
      List<int> occupantsIds, String dialogName, int dialogType);

  Future<Either<NetworkError, bool>> deleteDialog(String? dialogId);

  Future<Either<NetworkError, bool>> leaveDialog(String? dialogId);

  Future<Either<NetworkError, bool>> joinDialog(String? dialogId);

  Future<Either<NetworkError, List<int>>> getOnlineUsers(String? dialogId);

  Future<Either<NetworkError, bool>> sendMessage(
      String? dialogId, String messageBody);

  Future<Either<NetworkError, bool>> isJoinedDialog(String? dialogId);

  Future<Either<NetworkError, bool>> sendNotificationMessage(
      String? dialogId, String messageBody, int notificationType);

  Future<Either<NetworkError, bool>> sendSystemMessage(
      String? dialogId, int? recipientId, int notificationType);

  Future<Either<NetworkError, bool>> markMessageRead(QBMessageEntity message);

  Future<Either<NetworkError, bool>> markMessageDelivered(
      QBMessageEntity message);

  Future<Either<NetworkError, bool>> sendIsTyping(String? dialogId);

  Future<Either<NetworkError, bool>> sendStoppedTyping(String? dialogId);

  Future<Either<NetworkError, List<QBMessageEntity>>>
      getDialogMessagesByDateSent(String? dialogId,
          {int limit = 100, int skip = 0});

  Future<Either<NetworkError, QBMessageEntity>> getMessageById(
      String? dialogId, String? messageId);
  Future<StreamSubscription<dynamic>> subscribeChat();
  Future<StreamSubscription<dynamic>> subscribeIncomingMessage();
  Future<StreamSubscription<dynamic>> subscribeIncomingSystemMessage();
  Future<StreamSubscription<dynamic>> subscribeMessageRead();
  Future<StreamSubscription<dynamic>> subscribeMessageDelievered();
  Future<StreamSubscription<dynamic>> subscribeUserIsTyping();
  Future<StreamSubscription<dynamic>> subscribeUserStoppedTyping();
}
