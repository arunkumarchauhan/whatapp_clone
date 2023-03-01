import 'package:data/data.dart';
import 'package:quickblox_sdk/models/qb_custom_object_permission_level.dart';

extension CustomObjectPermissonLevelMapper on QBCustomObjectPermissionLevel {
  QBCustomObjectPermissionLevelEntity transform() {
    return QBCustomObjectPermissionLevelEntity(
        access: access, usersGroups: usersGroups, usersIds: usersIds);
  }
}
