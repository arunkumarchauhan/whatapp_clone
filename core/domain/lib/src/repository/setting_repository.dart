import '../../domain.dart';

abstract class SettingsRepository {
  Future<Either<NetworkError, bool>> init(
      String appId, String authKey, String authSecret, String accountKey,
      {String? apiEndpoint, String? chatEndpoint});

  Future<Either<NetworkError, QBSettingsEntity>> get();

  Future<Either<NetworkError, bool>> enableCarbons();
  Future<Either<NetworkError, bool>> disableCarbons();

  Future<Either<NetworkError, void>> initStreamManagement(
      bool autoReconnect, int messageTimeout);

  Future<Either<NetworkError, bool>> enableXMPPLogging();

  Future<Either<NetworkError, bool>> enableLogging();

  Future<Either<NetworkError, bool>> enableAutoReconnect(bool enable);
}
