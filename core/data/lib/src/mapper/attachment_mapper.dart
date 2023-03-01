import 'package:quickblox_sdk/models/qb_attachment.dart' as qb;
import 'package:shared/shared.dart';

extension QBAttachmentMapper on qb.QBAttachment {
  QBAttachmentEntity transform() {
    return QBAttachmentEntity(
        id: id,
        type: type,
        name: name,
        duration: duration,
        contentType: contentType,
        data: data,
        width: width,
        height: height,
        size: size,
        url: url);
  }
}
