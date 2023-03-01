import 'package:shared/src/model/message/qb_attachment.dart';

class QBMessageEntity {
  String? id;
  List<QBAttachmentEntity?>? attachments;
  Map<String, String>? properties;
  int? dateSent;
  int? senderId;
  int? recipientId;
  List<int>? readIds;
  List<int>? deliveredIds;
  String? dialogId;
  bool? markable;
  bool? delayed;
  String? body;

  @override
  String toString() {
    return 'QBMessageModel{id: $id, attachments: $attachments, properties: $properties, dateSent: $dateSent, senderId: $senderId, recipientId: $recipientId, readIds: $readIds, deliveredIds: $deliveredIds, dialogId: $dialogId, markable: $markable, delayed: $delayed, body: $body}';
  }

  QBMessageEntity(
      {this.id,
      this.attachments,
      this.properties,
      this.dateSent,
      this.senderId,
      this.recipientId,
      this.readIds,
      this.deliveredIds,
      this.dialogId,
      this.markable,
      this.delayed,
      this.body});
}
