import 'package:shared/shared.dart';

class QBLoginResultEntity {
  QBUserEntity? qbUser;
  QBSessionEntity? qbSession;

  QBLoginResultEntity(this.qbUser, this.qbSession);

  @override
  String toString() {
    return 'QBLoginResultModel{qbUser: $qbUser, qbSession: $qbSession}';
  }
}
