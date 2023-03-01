import 'package:data/src/mapper/event_mapper.dart';
import 'package:domain/domain.dart';
import 'package:quickblox_sdk/models/qb_event.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class EventsRepositoryImpl implements EventsRepository {
  @override
  Future<Either<NetworkError, List<QBEventEntity>>> createNotification(
      String type,
      String notificationEventType,
      int senderId,
      Map<String, Object> payload) async {
    try {
      final result = await QB.events
          .create(type, notificationEventType, senderId, payload);
      return Right(result
          .where((element) => element != null)
          .map((e) => e!.transform())
          .toList());
    } catch (e) {
      print("Exception in EventsRepository createNotification $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, QBEventEntity>> updateNotification(int id) async {
    QBEvent? qbEvent;
    try {
      qbEvent = await QB.events.update(id);
      int? notificationId = qbEvent?.id;
      if (qbEvent != null) {
        return Right(qbEvent.transform());
      }
    } catch (e) {
      print("Exception in EventsRepository updateNotification $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, bool>> removeNotification(int id) async {
    try {
      await QB.events.remove(id);
      return Right(true);
    } catch (e) {
      print("Exception in EventsRepository removeNotification $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, QBEventEntity>> getNotificationById(
      int id) async {
    try {
      final result = await QB.events.getById(id);
      if (result != null) {
        return Right(result.transform());
      }
    } catch (e) {
      print("Exception in EventsRepository getNotificationById $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, List<QBEventEntity>>> getNotifications() async {
    try {
      final result = await QB.events.get();
      return Right(result
          .where((element) => element != null)
          .map((e) => e!.transform())
          .toList());
    } catch (e) {
      print("Exception in EventsRepository getNotificationById $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }
}
