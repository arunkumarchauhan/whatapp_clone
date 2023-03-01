import 'package:data/src/mapper/custom_object_mapper.dart';
import 'package:domain/domain.dart';
import 'package:quickblox_sdk/models/qb_custom_object.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class CustomObjectsRepositoryImpl implements CustomObjectsRepository {
  @override
  Future<Either<NetworkError, QBCustomObjectEntity>> createCustomObject(
      String className, Map<String, Object> fieldsMap) async {
    QBCustomObject? customObject;
    try {
      List<QBCustomObject?> customObjectsList =
          await QB.data.create(className: className, fields: fieldsMap);
      customObject = customObjectsList[0];
      String? id = customObject?.id;
      if (customObject != null) {
        return Right(customObject.transform());
      }
    } catch (e) {
      print("Exception in CustomObjectsRepository createCustomObject $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, bool>> removeCustomObject(
      String className, List<String> ids) async {
    try {
      await QB.data.remove(className, ids);
      return Right(true);
    } catch (e) {
      print("Exception in CustomObjectsRepository removeCustomObject $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, List<QBCustomObjectEntity>>>
      getCustomObjectsByIds(String className, List<String> ids) async {
    List<QBCustomObject?> customObjects = [];
    try {
      customObjects = await QB.data.getByIds(className, ids);
      int size = customObjects.length;
      return Right(customObjects
          .where((element) => element != null)
          .map((e) => e!.transform())
          .toList());
    } catch (e) {
      print("Exception in CustomObjectsRepository getCustomObjectsByIds $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, List<QBCustomObjectEntity>>> getCustomObjects(
      String className) async {
    try {
      final result = await QB.data.get(className);
      return Right(result
          .where((element) => element != null)
          .map((e) => e!.transform())
          .toList());
    } catch (e) {
      print("Exception in CustomObjectsRepository getCustomObjects $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, bool>> updateCustomObject(
      String className, String objectId) async {
    try {
      List<QBCustomObject?> customObject =
          await QB.data.update(className, id: objectId);
      String? id = customObject[0]!.id;
      return Right(true);
    } catch (e) {
      print("Exception in CustomObjectsRepository updateCustomObject $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }
}
