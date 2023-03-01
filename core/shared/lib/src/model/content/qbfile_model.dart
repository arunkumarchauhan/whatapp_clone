class QBFileEntity {
  int? id;
  String? uid;
  String? contentType;
  String? name;
  int? size;
  String? completedAt;
  bool? isPublic;
  String? lastReadAccessTime;
  String? tags;

  QBFileEntity(
      {this.id,
      this.uid,
      this.contentType,
      this.name,
      this.size,
      this.completedAt,
      this.isPublic,
      this.lastReadAccessTime,
      this.tags});

  @override
  String toString() {
    return 'QBFileModel{id: $id, uid: $uid, contentType: $contentType, name: $name, size: $size, completedAt: $completedAt, isPublic: $isPublic, lastReadAccessTime: $lastReadAccessTime, tags: $tags}';
  }
}
