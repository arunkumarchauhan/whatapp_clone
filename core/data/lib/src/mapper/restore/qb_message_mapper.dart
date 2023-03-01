import 'package:data/data.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'qb_attachment_mapper.dart';

extension QBMessageRestore on QBMessageEntity {
  QBMessage restore() {
    final qbMessage = QBMessage()
      ..senderId = senderId
      ..recipientId = recipientId
      ..readIds = readIds
      ..properties = properties
      ..markable = markable
      ..dialogId = dialogId
      ..deliveredIds = deliveredIds
      ..delayed = delayed
      ..dateSent = dateSent
      ..body = body
      ..attachments = (attachments?.map((e) => e!.restore()).toList())
      ..id = id;
    return qbMessage;
  }
}
