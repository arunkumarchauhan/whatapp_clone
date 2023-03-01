import 'package:data/src/mapper/user_mapper.dart';
import 'package:data/src/mapper/filter_mapper.dart';
import 'package:data/src/mapper/sort_mapper.dart';

import 'package:domain/domain.dart';

import '../../data.dart';

class QBUserRepoImpl implements QBUserRepository {
  final NetworkPort networkPort;

  QBUserRepoImpl({required this.networkPort});

  @override
  Future<Either<NetworkError, QBUserEntity>> createUser(
      {required String username,
      required String fullName,
      required String password}) async {
    try {
      final result = await networkPort.createUser(
          username: username, fullName: fullName, password: password);
      if (result != null) {
        return Right(result.transform());
      }
    } catch (e) {
      print("Exception in createUser $e");
    }
    return Left(NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong"));
  }

  @override
  Future<Either<NetworkError, List<QBUserEntity>>> getUsers(
      int page, int perPage,
      {QBSortEntity? sort, QBFilterEntity? filter}) async {
    try {
      final result = await networkPort.getUsers(page, perPage,
          sort: sort?.restore(), filter: filter?.restore());

      return Right(result.map((e) => e!.transform()).toList());
    } catch (e) {
      print("Exception in getUsers $e");
    }
    return Left(
      NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong",
      ),
    );
  }

  @override
  Future<Either<NetworkError, List<QBUserEntity>>> getUsersByIds(
      List<int>? userIds) async {
    try {
      final result = await networkPort.getUsersByIds(userIds);

      return Right(result.map((e) => e!.transform()).toList());
    } catch (e) {
      print("Exception in getUsersByIds $e");
    }
    return Left(
      NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong",
      ),
    );
  }

  @override
  Future<Either<NetworkError, QBUserEntity>> updateUser(
      String username, String fullName) async {
    try {
      final result = await networkPort.updateUser(username, fullName);

      return Right(result!.transform());
    } catch (e) {
      print("Exception in updateUser $e");
    }
    return Left(
      NetworkError(
        httpError: -1,
        cause: Exception("Something went wrong"),
        message: "Something went wrong",
      ),
    );
  }
}
