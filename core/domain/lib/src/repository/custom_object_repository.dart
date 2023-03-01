import '../../domain.dart';

abstract class CustomObjectsRepository {
  Future<Either<NetworkError, QBCustomObjectEntity>> createCustomObject(
      String className, Map<String, Object> fieldsMap);

  Future<Either<NetworkError, bool>> removeCustomObject(
      String className, List<String> ids);

  Future<Either<NetworkError, List<QBCustomObjectEntity>>>
      getCustomObjectsByIds(String className, List<String> ids);

  Future<Either<NetworkError, List<QBCustomObjectEntity>>> getCustomObjects(
      String className);

  Future<Either<NetworkError, bool>> updateCustomObject(
      String className, String objectId);
}
