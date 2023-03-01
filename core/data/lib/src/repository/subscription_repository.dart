import 'package:data/src/mapper/subscription_mapper.dart';
import 'package:domain/domain.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class SubscriptionsRepositoryImpl implements SubscriptionsRepository {
  @override
  Future<Either<NetworkError, List<QBSubscriptionEntity>>>
      createPushSubscription(String deviceToken, String pushChannel) async {
    try {
      final result = await QB.subscriptions.create(deviceToken, pushChannel);
      return Right(result
          .where((element) => element != null)
          .map((e) => e!.transform())
          .toList());
    } catch (e) {
      print("Exception in SubscriptionsRepository createPushSubscription $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, List<QBSubscriptionEntity>>>
      getPushSubscriptions() async {
    try {
      final result = await QB.subscriptions.get();
      return Right(result
          .where((element) => element != null)
          .map((e) => e!.transform())
          .toList());
    } catch (e) {
      print("Exception in SubscriptionsRepository getPushSubscriptions $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, bool>> removePushSubscription(int id) async {
    try {
      await QB.subscriptions.remove(id);
      return Right(true);
    } catch (e) {
      print("Exception in SubscriptionsRepository removePushSubscription $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }
}
