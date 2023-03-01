import 'package:data/data.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/users/constants.dart';

import 'services/retrofit_service.dart';

class NetworkAdapter implements NetworkPort {
  final RetrofitService apiService;

  NetworkAdapter(this.apiService);

  @override
  void fetchPosts() {
    // TODO: implement fetchPosts
  }

  @override
  Future<QBUser?> createUser(
      {required String username,
      required String fullName,
      required String password}) {
    return QB.users.createUser(username, password, fullName: fullName);
  }

  @override
  Future<List<QBUser?>> getUsers(int page, int perPage,
      {QBSort? sort, QBFilter? filter}) async {
    return QB.users
        .getUsers(sort: sort, page: page, perPage: perPage, filter: filter);
  }

  @override
  Future<List<QBUser?>> getUsersByIds(List<int>? userIds) async {
    String? filterValue = userIds?.join(",");
    QBFilter filter = QBFilter();
    filter.field = QBUsersFilterFields.ID;
    filter.operator = QBUsersFilterOperators.IN;
    filter.value = filterValue;
    filter.type = QBUsersFilterTypes.STRING;

    return await QB.users.getUsers(filter: filter);
  }

  @override
  Future<QBUser?> updateUser(String username, String fullName) async {
    return QB.users.updateUser(login: username, fullName: fullName);
  }
}
