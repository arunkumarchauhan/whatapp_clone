class QBSettingsEntity {
  String? authKey;
  String? authSecret;
  String? apiEndpoint;
  String? appId;
  String? sdkVersion;
  String? chatEndpoint;
  String? accountKey;

  QBSettingsEntity(
      {this.authKey,
      this.authSecret,
      this.apiEndpoint,
      this.appId,
      this.sdkVersion,
      this.chatEndpoint,
      this.accountKey});

  @override
  String toString() {
    return 'QBSettingsModel{authKey: $authKey, authSecret: $authSecret, apiEndpoint: $apiEndpoint, appId: $appId, sdkVersion: $sdkVersion, chatEndpoint: $chatEndpoint, accountKey: $accountKey}';
  }
}
