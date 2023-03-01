import '../../domain.dart';

abstract class SubscriptionsRepository {
  Future<Either<NetworkError, List<QBSubscriptionEntity>>>
      createPushSubscription(String deviceToken, String pushChannel);

  Future<Either<NetworkError, List<QBSubscriptionEntity>>>
      getPushSubscriptions();

  Future<Either<NetworkError, bool>> removePushSubscription(int id);
}
