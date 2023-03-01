import 'dart:async';

import 'package:app/model/resource.dart';
import 'package:app/utils/extensions.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:statemanagement_riverpod/statemanagement_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../../utils/constants.dart';

class LoginViewModel extends BasePageViewModel {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController loginController = TextEditingController();
  LoginViewModel(
      this._authRepository, this._usersRepository, this._storageRepository);
  late final AuthRepository _authRepository;
  late final QBUserRepository _usersRepository;
  late final StorageRepository _storageRepository;
  late QBUserEntity? qbUserModel;
  final PublishSubject<Resource<QBUserEntity?>> _loginResponseSubject =
      PublishSubject();
  Stream<Resource<QBUserEntity?>> get loginResponseStream =>
      _loginResponseSubject.stream;

  void _createUser() async {
    final response = await _usersRepository.createUser(
        username: loginController.text,
        fullName: usernameController.text,
        password: DEFAULT_USER_PASSWORD);
    response.fold((l) {
      loadingSubject.safeAdd(false);
      _loginResponseSubject.safeAdd(
        Resource.error(
          data: null,
          error: AppError(
              throwable: Exception("Error Creating user in login bloc"),
              error: ErrorInfo(
                  message: "Error Creating user in login bloc ", code: -1),
              type: ErrorType.databaseError1),
        ),
      );
      debugPrint("Error Creating user in login bloc $l");
    }, (user) {
      loginQB();
    });
  }

  void _updateUser() async {
    final response = await _usersRepository.updateUser(
        loginController.text, usernameController.text);
    response.fold((l) {
      debugPrint("Error _updateUser in login bloc $l");
      loadingSubject.safeAdd(false);
      _loginResponseSubject.safeAdd(
        Resource.error(
          data: null,
          error: AppError(
              throwable: Exception("Error _updateUser in login bloc "),
              error: ErrorInfo(
                  message: "Error _updateUser in login bloc ", code: -1),
              type: ErrorType.databaseError1),
        ),
      );
    }, (user) {
      debugPrint("_updateUser  : User Updated successfully login bloc");
    });
  }

  void loginQB() async {
    String login = loginController.text.trim();
    String userName = usernameController.text.trim();
    loadingSubject.safeAdd(true);
    _loginResponseSubject.safeAdd(Resource.loading(data: null));
    final qbLoginResultEither =
        await _authRepository.login(login, DEFAULT_USER_PASSWORD);
    qbLoginResultEither.fold((l) {
      _createUser();
      debugPrint("QB Login Failed LoginViewModel Now creating user $l ");
      // _loginResponseSubject.safeAdd(Resource.error(
      //   data: null,
      //   error: AppError(
      //     throwable: Exception("QB Login Failed LoginViewModel"),
      //     error: ErrorInfo(message: "QB Login Failed LoginViewModel"),
      //     type: ErrorType.databaseUserNotFound,
      //   ),
      // ));
    }, (qbLoginResult) {
      if (qbLoginResult.qbUser?.id != null) {
        _storageRepository.saveUserId(qbLoginResult.qbUser!.id!);
        _storageRepository.saveUserLogin(login);
        _storageRepository.saveUserFullName(userName);
        _storageRepository.saveUserPassword(DEFAULT_USER_PASSWORD);

        if (qbLoginResult.qbUser!.fullName != userName) {
          _updateUser();
        } else {
          qbUserModel = qbLoginResult.qbUser;
          loadingSubject.safeAdd(false);
          _loginResponseSubject.safeAdd(Resource.success(data: qbUserModel));
          debugPrint("LoginView Model Login Success");
        }
      } else {
        loadingSubject.safeAdd(false);
        _loginResponseSubject.safeAdd(Resource.error(
          data: null,
          error: AppError(
            throwable: Exception("User is null"),
            error: ErrorInfo(message: "User is null"),
            type: ErrorType.databaseUserNotFound,
          ),
        ));
        debugPrint("User is null");
      }
    });
  }
}
