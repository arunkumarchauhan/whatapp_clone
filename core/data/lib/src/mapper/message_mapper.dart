import 'package:data/data.dart';
import 'package:data/src/mapper/attachment_mapper.dart';
import 'package:quickblox_sdk/models/qb_message.dart';

extension QBMessageMapper on QBMessage {
  QBMessageEntity transform() {
    return QBMessageEntity(
      id: id,
      attachments: (attachments ?? []).map((e) => e!.transform()).toList(),
      body: body,
      dateSent: dateSent,
      delayed: delayed,
      deliveredIds: deliveredIds,
      dialogId: dialogId,
      markable: markable,
      properties: properties,
      readIds: readIds,
      recipientId: recipientId,
      senderId: senderId,
    );
  }
}
