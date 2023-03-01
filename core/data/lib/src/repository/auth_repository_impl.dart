import 'package:data/src/mapper/login_result.dart';
import 'package:data/src/mapper/session_mapper.dart';
import 'package:domain/domain.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<NetworkError, QBLoginResultEntity>> login(
      String login, String password) async {
    try {
      final result = (await QB.auth.login(login, password));
      return Right(result.transform());
    } catch (e) {
      print("Exception in login Repo $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, void>> logout() async {
    try {
      await QB.auth.logout();
    } catch (e) {
      print("Exception in logout Repo $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, QBSessionEntity>> createSession(
      QBSessionEntity qbSession) async {
    try {
      final result =
          (await QB.auth.setSession(qbSession.restore()) as QBSession);

      return Right(result.transform());
    } catch (e) {
      print("Exception in createSession Repo $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, QBSessionEntity>> getSession() async {
    try {
      final result = (await QB.auth.getSession()) as QBSession;
      return Right(result.transform());
    } catch (e) {
      print("Exception in getSession Repo $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }
}
