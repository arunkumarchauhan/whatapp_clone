class QBEventEntity {
  int? id;
  String? name;
  bool? active;
  String? notificationType;
  int? pushType;
  double? date;
  int? endDate;
  String? period;
  int? occuredCount;
  int? senderId;
  List<String>? recipientsIds;
  List<String>? recipientsTagsAny;
  List<String>? recipientsTagsAll;
  List<String>? recipientsTagsExclude;
  String? payload;

  QBEventEntity(
      {this.id,
      this.name,
      this.active,
      this.notificationType,
      this.pushType,
      this.date,
      this.endDate,
      this.period,
      this.occuredCount,
      this.senderId,
      this.recipientsIds,
      this.recipientsTagsAny,
      this.recipientsTagsAll,
      this.recipientsTagsExclude,
      this.payload});

  @override
  String toString() {
    return 'QBEventModel{id: $id, name: $name, active: $active, notificationType: $notificationType, pushType: $pushType, date: $date, endDate: $endDate, period: $period, occuredCount: $occuredCount, senderId: $senderId, recipientsIds: $recipientsIds, recipientsTagsAny: $recipientsTagsAny, recipientsTagsAll: $recipientsTagsAll, recipientsTagsExclude: $recipientsTagsExclude, payload: $payload}';
  }
}
