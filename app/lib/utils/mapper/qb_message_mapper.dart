import 'dart:collection';

import 'package:app/utils/mapper/qb_attachment_mapper.dart';
import 'package:domain/domain.dart';

class QBMessageMapper {
  static QBMessageEntity? mapToQBMessage(Map<dynamic, dynamic>? map) {
    if (map == null || map.isEmpty) {
      return null;
    }

    QBMessageEntity qbMessage = QBMessageEntity();

    if (map.containsKey("id")) {
      qbMessage.id = map["id"] as String?;
    }
    if (map.containsKey("attachments")) {
      List<Object?> attachmentsMapsList = map["attachments"] as List<Object?>;

      List<QBAttachmentEntity?> attachmentsList = [];
      for (final attachmentDynamicMap in attachmentsMapsList) {
        Map<String, Object> attachmentMap = Map<String, Object>.from(
            attachmentDynamicMap as Map<dynamic, dynamic>);
        QBAttachmentEntity? qbAttachment = QBAttachmentEntity(
          type: attachmentMap['type'] as String?,
          width: attachmentMap["width"] as int?,
          duration: attachmentMap["duration"] as int?,
          id: attachmentMap["id"] as String?,
          url: attachmentMap["url"] as String?,
          name: attachmentMap["name"] as String?,
          contentType: attachmentMap["contentType"] as String?,
          size: attachmentMap["size"] as double?,
          height: attachmentMap["height"] as int?,
          data: attachmentMap["data"] as String?,
        );

        attachmentsList.add(qbAttachment);
      }
      qbMessage.attachments = attachmentsList;
    }
    if (map.containsKey("properties")) {
      LinkedHashMap<dynamic, dynamic> hashMap =
          map["properties"] as LinkedHashMap<dynamic, dynamic>;

      Map<String, String> propertiesMap = hashMap
          .map((key, value) => MapEntry(key as String, value.toString()));

      qbMessage.properties = propertiesMap;
    }
    if (map.containsKey("dateSent")) {
      qbMessage.dateSent = map["dateSent"] as int?;
    }
    if (map.containsKey("senderId")) {
      qbMessage.senderId = map["senderId"] as int?;
    }
    if (map.containsKey("recipientId")) {
      qbMessage.recipientId = map["recipientId"] as int?;
    }
    if (map.containsKey("readIds")) {
      qbMessage.readIds = List.from(map["readIds"] as Iterable<dynamic>);
    }
    if (map.containsKey("deliveredIds")) {
      qbMessage.deliveredIds =
          List.from(map["deliveredIds"] as Iterable<dynamic>);
    }
    if (map.containsKey("dialogId")) {
      qbMessage.dialogId = map["dialogId"] as String?;
    }
    if (map.containsKey("markable")) {
      qbMessage.markable = map["markable"] as bool?;
    }
    if (map.containsKey("delayed")) {
      qbMessage.delayed = map["delayed"] as bool?;
    }
    if (map.containsKey("body")) {
      qbMessage.body = map["body"] as String?;
    }

    return qbMessage;
  }

  static Map<String, Object>? qbMessageToMap(QBMessageEntity? qbMessage) {
    if (qbMessage == null) {
      return null;
    }

    Map<String, Object> messageMap = {};

    messageMap["id"] = qbMessage.id as Object;

    List<Map<String, Object>?> attachmentMapsList = [];

    if (qbMessage.attachments != null) {
      for (QBAttachmentEntity? attachment
          in qbMessage.attachments as List<QBAttachmentEntity?>) {
        Map<String, Object>? attachmentMap =
            QBAttachmentMapper.qbAttachmentToMap(attachment);

        if (attachmentMap != null) {
          attachmentMapsList.add(attachmentMap);
        }
      }
    }

    messageMap["attachments"] = attachmentMapsList;

    if (qbMessage.properties != null) {
      messageMap["properties"] = qbMessage.properties as Object;
    }
    if (qbMessage.dateSent != null) {
      messageMap["dateSent"] = qbMessage.dateSent as Object;
    }
    if (qbMessage.senderId != null) {
      messageMap["senderId"] = qbMessage.senderId as Object;
    }
    if (qbMessage.recipientId != null) {
      messageMap["recipientId"] = qbMessage.recipientId as Object;
    }
    if (qbMessage.readIds != null) {
      messageMap["readIds"] = qbMessage.readIds as Object;
    }
    if (qbMessage.deliveredIds != null) {
      messageMap["deliveredIds"] = qbMessage.deliveredIds as Object;
    }
    if (qbMessage.dialogId != null) {
      messageMap["dialogId"] = qbMessage.dialogId as Object;
    }
    if (qbMessage.markable != null) {
      messageMap["markable"] = qbMessage.markable as Object;
    }
    if (qbMessage.delayed != null) {
      messageMap["delayed"] = qbMessage.delayed as Object;
    }
    if (qbMessage.body != null) {
      messageMap["body"] = qbMessage.body as Object;
    }

    return messageMap;
  }
}
