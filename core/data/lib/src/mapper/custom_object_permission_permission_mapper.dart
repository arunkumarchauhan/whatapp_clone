import 'package:data/src/mapper/custom_object_permission_level_mapper.dart';
import 'package:quickblox_sdk/models/qb_custom_object_permission.dart';
import 'package:shared/shared.dart';

extension CustomObjectPermissionMapper on QBCustomObjectPermission {
  QBCustomObjectPermissionEntity transform() {
    return QBCustomObjectPermissionEntity(
        customObjectId: customObjectId,
        deleteLevel: deleteLevel?.transform(),
        readLevel: readLevel?.transform(),
        updateLevel: updateLevel?.transform());
  }
}
