import 'package:data/src/mapper/user_mapper.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:shared/shared.dart';
import 'session_mapper.dart';

extension QBLoginResultMapper on QBLoginResult {
  QBLoginResultEntity transform() {
    return QBLoginResultEntity(qbUser?.transform(), qbSession?.transform());
  }
}
