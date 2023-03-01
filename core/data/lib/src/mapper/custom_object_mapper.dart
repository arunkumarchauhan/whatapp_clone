import 'package:data/data.dart';
import 'package:data/src/mapper/custom_object_permission_permission_mapper.dart';
import 'package:quickblox_sdk/models/qb_custom_object.dart';

extension CustomObjectMapper on QBCustomObject {
  QBCustomObjectEntity transform() {
    return QBCustomObjectEntity(
      id: id,
      updatedAt: updatedAt,
      createdAt: createdAt,
      userId: userId,
      className: className,
      fields: fields,
      parentId: parentId,
      permission: permission?.transform(),
    );
  }
}
