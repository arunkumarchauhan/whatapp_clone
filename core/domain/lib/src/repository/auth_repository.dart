import '../../domain.dart';

abstract class AuthRepository {
  Future<Either<NetworkError, QBLoginResultEntity>> login(
      String login, String password);

  Future<Either<NetworkError, void>> logout();

  Future<Either<NetworkError, QBSessionEntity>> createSession(
      QBSessionEntity qbSession);

  Future<Either<NetworkError, QBSessionEntity>> getSession();
}
