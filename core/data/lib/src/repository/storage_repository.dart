import 'package:domain/domain.dart';
import 'package:hive_flutter/adapters.dart';

class StorageRepositoryImpl implements StorageRepository {
  static const int NOT_SAVED_USER_ID = -1;
  static const String USER_ID_KEY = "user_id_key";
  static const String USER_LOGIN_KEY = "user_login_key";
  static const String USER_FULL_NAME_KEY = "user_full_name_key";
  static const String USER_PASSWORD_KEY = "user_password_key";

  final _hiveBox = Hive.openBox("storage");

  @override
  void saveUserId(int userId) async {
    var box = await _hiveBox;
    box.put(USER_ID_KEY, userId);
  }

  @override
  Future<int> getUserId() async {
    var box = await _hiveBox;
    return box.get(USER_ID_KEY) ?? NOT_SAVED_USER_ID;
  }

  @override
  void saveUserLogin(String login) async {
    var box = await _hiveBox;
    box.put(USER_LOGIN_KEY, login);
  }

  @override
  Future<String> getUserLogin() async {
    var box = await _hiveBox;
    return box.get(USER_LOGIN_KEY, defaultValue: "");
  }

  @override
  void saveUserFullName(String fullName) async {
    var box = await _hiveBox;
    box.put(USER_FULL_NAME_KEY, fullName);
  }

  @override
  Future<String> getUserFullName() async {
    var box = await _hiveBox;
    return box.get(USER_FULL_NAME_KEY, defaultValue: "");
  }

  @override
  void saveUserPassword(String password) async {
    var box = await _hiveBox;
    box.put(USER_PASSWORD_KEY, password);
  }

  @override
  Future<String> getUserPassword() async {
    var box = await _hiveBox;
    return box.get(USER_PASSWORD_KEY, defaultValue: "");
  }

  @override
  void cleanCredentials() async {
    saveUserId(NOT_SAVED_USER_ID);
    saveUserLogin("");
    saveUserFullName("");
    saveUserPassword("");
  }
}
