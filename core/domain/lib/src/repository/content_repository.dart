import '../../domain.dart';

abstract class ContentRepository {
  Future<Either<NetworkError, QBFileEntity>> upload(String url);

  Future<Either<NetworkError, QBFileEntity>> getInfo(int fileId);

  Future<Either<NetworkError, String>> getPublicURL(String uid);

  Future<Either<NetworkError, String>> getPrivateURL(String uid);
}
