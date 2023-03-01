import 'package:quickblox_sdk/models/qb_settings.dart';

import '../../data.dart';

extension QBSettingMapper on QBSettings {
  QBSettingsEntity transform() {
    return QBSettingsEntity(
        accountKey: accountKey,
        apiEndpoint: apiEndpoint,
        appId: appId,
        authKey: authKey,
        authSecret: authSecret,
        chatEndpoint: chatEndpoint,
        sdkVersion: sdkVersion);
  }
}
