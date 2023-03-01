class QBSessionEntity {
  int? userId;
  int? applicationId;
  String? token;
  String? expirationDate;

  @override
  String toString() {
    return 'QBSessionModel{userId: $userId, applicationId: $applicationId, token: $token, expirationDate: $expirationDate}';
  }

  QBSessionEntity(
      {this.userId, this.applicationId, this.token, this.expirationDate});
}
