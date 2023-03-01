import 'package:data/data.dart';
import 'package:quickblox_sdk/models/qb_user.dart';

extension QBUserMapper on QBUser {
  QBUserEntity transform() {
    return QBUserEntity(
        id: id,
        blobId: blobId,
        customData: customData,
        phone: phone,
        login: login,
        email: email,
        externalId: externalId,
        facebookId: facebookId,
        fullName: fullName,
        lastRequestAt: lastRequestAt,
        tags: tags,
        twitterId: twitterId,
        website: website);
  }
}
