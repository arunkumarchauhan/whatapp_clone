import 'package:data/data.dart';
import 'package:quickblox_sdk/models/qb_attachment.dart' show QBAttachment;

extension QBAttachmentRestore on QBAttachmentEntity {
  QBAttachment restore() {
    return QBAttachment()
      ..id = id
      ..url = url
      ..size = size
      ..height = height
      ..width = width
      ..contentType = contentType
      ..duration = duration
      ..type = type
      ..data = data
      ..name = name;
  }
}
