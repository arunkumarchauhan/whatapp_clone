abstract class StorageRepository {
  void saveUserId(int userId);

  Future<int> getUserId();

  void saveUserLogin(String login);

  Future<String> getUserLogin();

  void saveUserFullName(String fullName);
  Future<String> getUserFullName();
  void saveUserPassword(String password);
  Future<String> getUserPassword();

  void cleanCredentials();
}
