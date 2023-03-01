import 'package:data/data.dart';

class QBAttachmentMapper {
  static QBAttachmentEntity? mapToQBAttachment(Map<dynamic, dynamic>? map) {
    if (map == null || map.isEmpty) {
      return null;
    }

    QBAttachmentEntity qbAttachment = QBAttachmentEntity();

    if (map.containsKey("type") && map["type"] != null) {
      qbAttachment.type = map["type"] as String?;
    }
    if (map.containsKey("id") && map["id"] != null) {
      qbAttachment.id = map["id"] as String?;
    }
    if (map.containsKey("url") && map["url"] != null) {
      qbAttachment.url = map["url"] as String?;
    }
    if (map.containsKey("name") && map["name"] != null) {
      qbAttachment.name = map["name"] as String?;
    }
    if (map.containsKey("contentType") && map["contentType"] != null) {
      qbAttachment.contentType = map["contentType"] as String?;
    }
    if (map.containsKey("data") && map["data"] != null) {
      qbAttachment.data = map["data"] as String?;
    }
    if (map.containsKey("size") && map["size"] != null) {
      qbAttachment.size = map["size"] as double?;
    }
    if (map.containsKey("height") && map["height"] != null) {
      qbAttachment.height = map["height"] as int?;
    }
    if (map.containsKey("width") && map["width"] != null) {
      qbAttachment.width = map["width"] as int?;
    }
    if (map.containsKey("duration") && map["duration"] != null) {
      qbAttachment.duration = map["duration"] as int?;
    }

    return qbAttachment;
  }

  static Map<String, Object>? qbAttachmentToMap(
      QBAttachmentEntity? qbAttachment) {
    if (qbAttachment == null) {
      return null;
    }

    Map<String, Object> map = {};

    if (qbAttachment.type != null) {
      map["type"] = qbAttachment.type as Object;
    }
    if (qbAttachment.id != null) {
      map["id"] = qbAttachment.id as Object;
    }
    if (qbAttachment.url != null) {
      map["url"] = qbAttachment.url as Object;
    }
    if (qbAttachment.name != null) {
      map["name"] = qbAttachment.name as Object;
    }
    if (qbAttachment.contentType != null) {
      map["contentType"] = qbAttachment.contentType as Object;
    }
    if (qbAttachment.data != null) {
      map["data"] = qbAttachment.data as Object;
    }
    if (qbAttachment.size != null) {
      map["size"] = qbAttachment.size as Object;
    }
    if (qbAttachment.height != null) {
      map["height"] = qbAttachment.height as Object;
    }
    if (qbAttachment.width != null) {
      map["width"] = qbAttachment.width as Object;
    }
    if (qbAttachment.duration != null) {
      map["duration"] = qbAttachment.duration as Object;
    }

    return map;
  }
}
