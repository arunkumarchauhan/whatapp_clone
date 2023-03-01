import 'package:shared/src/model/custom_object/custom_object_permission_model.dart';

class QBCustomObjectEntity {
  String? id;
  String? parentId;
  String? createdAt;
  String? updatedAt;
  String? className;
  int? userId;
  Map<String, Object>? fields;
  QBCustomObjectPermissionEntity? permission;

  QBCustomObjectEntity(
      {this.id,
      this.parentId,
      this.createdAt,
      this.updatedAt,
      this.className,
      this.userId,
      this.fields,
      this.permission});

  @override
  String toString() {
    return 'QBCustomObjectModel{id: $id, parentId: $parentId, createdAt: $createdAt, updatedAt: $updatedAt, className: $className, userId: $userId, fields: $fields, permission: $permission}';
  }
}
