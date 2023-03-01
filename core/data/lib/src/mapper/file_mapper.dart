import 'package:data/data.dart';
import 'package:quickblox_sdk/models/qb_file.dart';

extension QBFileMapper on QBFile {
  QBFileEntity transform() {
    return QBFileEntity(
        id: id,
        size: size,
        contentType: contentType,
        name: name,
        tags: tags,
        completedAt: completedAt,
        isPublic: isPublic,
        lastReadAccessTime: lastReadAccessTime,
        uid: uid);
  }
}
