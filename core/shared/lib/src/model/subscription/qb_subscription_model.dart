class QBSubscriptionEntity {
  int? id;

  String? deviceUdid;
  String? deviceToken;
  String? devicePlatform;
  String? pushChannel;

  QBSubscriptionEntity(
      {this.id,
      this.deviceUdid,
      this.deviceToken,
      this.devicePlatform,
      this.pushChannel});
  @override
  String toString() {
    return 'QBSubscriptionModel{id: $id, deviceUdid: $deviceUdid, deviceToken: $deviceToken, devicePlatform: $devicePlatform, pushChannel: $pushChannel}';
  }
}
