class QBDialogEntity {
  bool? isJoined;
  String? createdAt;
  String? lastMessage;
  int? lastMessageDateSent;
  int? lastMessageUserId;
  String? name;
  String? photo;
  int? type;
  int? unreadMessagesCount;
  String? updatedAt;
  int? userId;
  String? roomJid;
  String? id;
  List<int>? occupantsIds;
  Map<Object?, Object?>? customData;

  QBDialogEntity(
      {this.isJoined,
      this.createdAt,
      this.lastMessage,
      this.lastMessageDateSent,
      this.lastMessageUserId,
      this.name,
      this.photo,
      this.type,
      this.unreadMessagesCount,
      this.updatedAt,
      this.userId,
      this.roomJid,
      this.id,
      this.occupantsIds,
      this.customData});

  @override
  String toString() {
    return 'QBDialogModel{isJoined: $isJoined, createdAt: $createdAt, lastMessage: $lastMessage, lastMessageDateSent: $lastMessageDateSent, lastMessageUserId: $lastMessageUserId, name: $name, photo: $photo, type: $type, unreadMessagesCount: $unreadMessagesCount, updatedAt: $updatedAt, userId: $userId, roomJid: $roomJid, id: $id, occupantsIds: $occupantsIds, customData: $customData}';
  }
}
