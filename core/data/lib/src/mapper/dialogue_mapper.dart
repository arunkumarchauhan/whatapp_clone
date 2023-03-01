import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:shared/shared.dart';

extension QBDialogueMapper on QBDialog {
  QBDialogEntity transformToDialogueEntity() {
    return QBDialogEntity(
        userId: userId,
        name: name,
        createdAt: createdAt,
        type: type,
        id: id,
        customData: customData,
        isJoined: isJoined,
        lastMessage: lastMessage,
        lastMessageDateSent: lastMessageDateSent,
        lastMessageUserId: lastMessageUserId,
        occupantsIds: occupantsIds,
        photo: photo,
        roomJid: roomJid,
        unreadMessagesCount: unreadMessagesCount,
        updatedAt: updatedAt);
  }
}
