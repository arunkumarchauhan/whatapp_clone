import 'dart:async';

import 'package:app/model/resource.dart';
import 'package:app/utils/extensions.dart';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_errors/flutter_errors.dart';
import 'package:injectable/injectable.dart';
import 'package:statemanagement_riverpod/statemanagement_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../utils/constants.dart';

@injectable
class SplashViewModel extends BasePageViewModel {
  final StreamController<bool> _navigateToDashboardController =
      StreamController();
  final FlutterExceptionHandlerBinder exceptionHandlerBinder;
  late Timer future;
  final SettingsRepository _settingsRepository;
  final AuthRepository _authRepository;
  final StorageRepository _storageRepository;
  final BehaviorSubject<Status> _loginResponseSubject =
      BehaviorSubject.seeded(Status.none);

  Stream<Status> get loginResponseStream => _loginResponseSubject.stream;

  SplashViewModel(this._authRepository, this._settingsRepository,
      this._storageRepository, this.exceptionHandlerBinder) {
    future = Timer(const Duration(seconds: 2), () async {
      _navigateToDashboardController.sink.add(true);
      _setSettings();
      _navigateToDashboardController.close();
    });
  }

  Stream<bool> navigateToDashboard() => _navigateToDashboardController.stream;

  void test() {}
  Future<void> _setSettings() async {
    try {
      await _settingsRepository.init(
          APPLICATION_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY);
      await _settingsRepository.initStreamManagement(true, 5);
      // for testing
      await _settingsRepository.enableXMPPLogging();
      await _settingsRepository.enableLogging();

      _initSavedUser();
    } catch (e) {
      _loginResponseSubject.safeAdd(Status.error);
      debugPrint("_setSetting SplashVM $e");
    }
  }

  void _initSavedUser() async {
    int userId = await _storageRepository.getUserId();
    if (userId != -1) {
      _login();
    } else {
      _loginResponseSubject.safeAdd(Status.error);
    }
  }

  void _login() async {
    try {
      String userLogin = await _storageRepository.getUserLogin();
      String userPassword = await _storageRepository.getUserPassword();
      final qbLoginResult =
          await _authRepository.login(userLogin, userPassword);
      qbLoginResult.fold((l) {
        debugPrint("Failed to login left $l");
        _loginResponseSubject.safeAdd(Status.error);
      }, (r) {
        if (r.qbUser?.id != null) {
          _storageRepository.saveUserId(r.qbUser!.id!);
          _loginResponseSubject.safeAdd(Status.success);
        } else {
          _loginResponseSubject.safeAdd(Status.error);
        }
      });
    } catch (e) {
      _loginResponseSubject.safeAdd(Status.error);
      debugPrint("Exception in _login SplashVM $e");
    }
  }

  @override
  void dispose() {
    future.cancel();
    _navigateToDashboardController.close();
    _loginResponseSubject.close();
    super.dispose();
  }
}
