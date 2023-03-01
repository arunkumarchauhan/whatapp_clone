import 'package:domain/domain.dart';

abstract class QBUserRepository {
  Future<Either<NetworkError, QBUserEntity>> createUser(
      {required String username,
      required String fullName,
      required String password});

  Future<Either<NetworkError, List<QBUserEntity>>> getUsers(
      int page, int perPage,
      {QBSortEntity? sort, QBFilterEntity? filter});
  Future<Either<NetworkError, List<QBUserEntity>>> getUsersByIds(
      List<int>? userIds);
  Future<Either<NetworkError, QBUserEntity>> updateUser(
      String username, String fullName);
}
