import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/models/qb_user.dart';

abstract class NetworkPort {
  void fetchPosts();
  Future<QBUser?> createUser(
      {required String username,
      required String fullName,
      required String password});
  Future<List<QBUser?>> getUsers(int page, int perPage,
      {QBSort? sort, QBFilter? filter});
  Future<List<QBUser?>> getUsersByIds(List<int>? userIds);
  Future<QBUser?> updateUser(String login, String fullName);
}
