import 'package:data/data.dart';
import 'package:quickblox_sdk/models/qb_subscription.dart';

extension QBSubscriptionMapper on QBSubscription {
  QBSubscriptionEntity transform() {
    return QBSubscriptionEntity(
        id: id,
        devicePlatform: devicePlatform,
        deviceToken: deviceToken,
        deviceUdid: deviceUdid,
        pushChannel: pushChannel);
  }
}
