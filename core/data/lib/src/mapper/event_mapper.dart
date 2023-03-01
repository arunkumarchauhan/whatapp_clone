import 'package:data/data.dart';
import 'package:quickblox_sdk/models/qb_event.dart';

extension QBEventMapper on QBEvent {
  QBEventEntity transform() {
    return QBEventEntity(
        id: id,
        name: name,
        senderId: senderId,
        date: date,
        active: active,
        endDate: endDate,
        notificationType: notificationType,
        occuredCount: occuredCount,
        payload: payload,
        period: period,
        pushType: pushType,
        recipientsIds: recipientsIds,
        recipientsTagsAll: recipientsTagsAll,
        recipientsTagsAny: recipientsTagsAny,
        recipientsTagsExclude: recipientsTagsExclude);
  }
}
