import 'package:app/di/states/viewmodels.dart';
import 'package:app/feature/login/login_page_view.dart';
import 'package:app/feature/login/login_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:statemanagement_riverpod/statemanagement_riverpod.dart';

class LoginPage extends BasePage<LoginViewModel> {
  const LoginPage({Key? key}) : super(key: key);
  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends BaseStatefulPage<LoginViewModel, LoginPage> {
  @override
  Widget buildView(BuildContext context, LoginViewModel model) {
    return LoginPageView(provideBase());
  }

  @override
  ProviderBase<LoginViewModel> provideBase() {
    return loginViewModelProvider;
  }
}
