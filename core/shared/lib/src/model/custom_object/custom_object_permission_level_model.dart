class QBCustomObjectPermissionLevelEntity {
  String? access;

  List<String>? usersIds;
  List<String>? usersGroups;
  QBCustomObjectPermissionLevelEntity(
      {this.access, this.usersIds, this.usersGroups});

  @override
  String toString() {
    return 'QBCustomObjectPermissionLevelModel{access: $access, usersIds: $usersIds, usersGroups: $usersGroups}';
  }
}
