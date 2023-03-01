import 'package:data/src/mapper/file_mapper.dart';
import 'package:domain/domain.dart';
import 'package:quickblox_sdk/models/qb_file.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class ContentRepositoryImpl implements ContentRepository {
  @override
  Future<Either<NetworkError, QBFileEntity>> upload(String url) async {
    try {
      final result = await QB.content.upload(url);
      if (result != null) {
        return Right(result.transform());
      }
    } catch (e) {
      print("Exception in ContentRepository upload $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, QBFileEntity>> getInfo(int fileId) async {
    QBFile? file;
    try {
      final file = await QB.content.getInfo(fileId);
      if (file != null) {
        return Right(file.transform());
      }
    } catch (e) {
      print("Exception in ContentRepository getInfo $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, String>> getPublicURL(String uid) async {
    try {
      final result = await QB.content.getPublicURL(uid);
      if (result != null) {
        return Right(result);
      }
    } catch (e) {
      print("Exception in ContentRepository getPublicURL $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }

  @override
  Future<Either<NetworkError, String>> getPrivateURL(String uid) async {
    try {
      final result = await QB.content.getPrivateURL(uid);
      if (result != null) {
        return Right(result);
      }
    } catch (e) {
      print("Exception in ContentRepository getPrivateURL $e");
    }
    return Left(
      NetworkError(
          cause: Exception("Something went wrong"),
          httpError: -1,
          message: "Something went wrong"),
    );
  }
}
