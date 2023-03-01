import 'package:shared/src/model/custom_object/custom_object_permission_level_model.dart';

class QBCustomObjectPermissionEntity {
  String? customObjectId;
  QBCustomObjectPermissionLevelEntity? readLevel;
  QBCustomObjectPermissionLevelEntity? updateLevel;
  QBCustomObjectPermissionLevelEntity? deleteLevel;

  QBCustomObjectPermissionEntity({
    this.customObjectId,
    this.readLevel,
    this.updateLevel,
    this.deleteLevel,
  });

  @override
  String toString() {
    return 'QBCustomObjectPermissionModel{customObjectId: $customObjectId, readLevel: $readLevel, updateLevel: $updateLevel, deleteLevel: $deleteLevel}';
  }
}
