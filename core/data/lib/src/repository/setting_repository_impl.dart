import 'package:data/src/mapper/setting_mapper.dart';
import 'package:domain/domain.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Future<Either<NetworkError, bool>> init(
      String appId, String authKey, String authSecret, String accountKey,
      {String? apiEndpoint, String? chatEndpoint}) async {
    try {
      await QB.settings.init(appId, authKey, authSecret, accountKey,
          apiEndpoint: apiEndpoint, chatEndpoint: chatEndpoint);
      return Right(true);
    } catch (e) {
      print("Exception in SettingRepository init SettingRepository $e");
      return Left(NetworkError(
          httpError: -1,
          cause: Exception("Something went wrong"),
          message: "Something went wrong"));
    }
  }

  @override
  Future<Either<NetworkError, QBSettingsEntity>> get() async {
    try {
      final result = await QB.settings.get();
      if (result != null) {
        return Right(result.transform());
      }
    } catch (e) {
      print("Exception in Setting Repository get SettingRepository $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, bool>> enableCarbons() async {
    try {
      await QB.settings.enableCarbons();
      return Right(true);
    } catch (e) {
      print(
          "Exception in Setting Repository enableCarbons SettingRepository $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, bool>> disableCarbons() async {
    try {
      await QB.settings.disableCarbons();
      return Right(true);
    } catch (e) {
      print(
          "Exception in Setting Repository disableCarbons SettingRepository $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, void>> initStreamManagement(
      bool autoReconnect, int messageTimeout) async {
    try {
      await QB.settings
          .initStreamManagement(messageTimeout, autoReconnect: autoReconnect);
      return Right(null);
    } catch (e) {
      print(
          "Exception in Setting Repository initStreamManagement SettingRepository $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, bool>> enableXMPPLogging() async {
    try {
      await QB.settings.enableXMPPLogging();
      return Right(true);
    } catch (e) {
      print(
          "Exception in Setting Repository enableXMPPLogging SettingRepository $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, bool>> enableLogging() async {
    try {
      await QB.settings.enableLogging();
      return Right(true);
    } catch (e) {
      print(
          "Exception in Setting Repository enableLogging SettingRepository $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, bool>> enableAutoReconnect(bool enable) async {
    try {
      await QB.settings.enableAutoReconnect(enable);
      return Right(true);
    } catch (e) {
      print(
          "Exception in Setting Repository enableAutoReconnect SettingRepository $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }
}
