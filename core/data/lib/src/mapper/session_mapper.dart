import 'package:data/data.dart';
import 'package:quickblox_sdk/models/qb_session.dart';

extension QbSessionMapper on QBSession {
  QBSessionEntity transform() {
    return QBSessionEntity(
        userId: userId,
        applicationId: applicationId,
        expirationDate: expirationDate,
        token: token);
  }
}

extension QBSessionRestore on QBSessionEntity {
  QBSession restore() {
    final qbSession = QBSession()
      ..token = token
      ..expirationDate = expirationDate
      ..applicationId = applicationId
      ..userId = userId;
    return qbSession;
  }
}
