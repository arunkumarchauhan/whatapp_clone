class QBAttachmentEntity {
  String? type;
  String? id;
  String? url;
  String? name;
  String? contentType;
  String? data;
  double? size;
  int? height;
  int? width;
  int? duration;

  QBAttachmentEntity(
      {this.type,
      this.id,
      this.url,
      this.name,
      this.contentType,
      this.data,
      this.size,
      this.height,
      this.width,
      this.duration});

  @override
  String toString() {
    return 'QBAttachmentModel{type: $type, id: $id, url: $url, name: $name, contentType: $contentType, data: $data, size: $size, height: $height, width: $width, duration: $duration}';
  }
}
