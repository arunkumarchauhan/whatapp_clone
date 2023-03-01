import '../../domain.dart';

abstract class EventsRepository {
  Future<Either<NetworkError, List<QBEventEntity>>> createNotification(
      String type,
      String notificationEventType,
      int senderId,
      Map<String, Object> payload);

  Future<Either<NetworkError, QBEventEntity>> updateNotification(int id);

  Future<Either<NetworkError, bool>> removeNotification(int id);

  Future<Either<NetworkError, QBEventEntity>> getNotificationById(int id);

  Future<Either<NetworkError, List<QBEventEntity>>> getNotifications();
}
