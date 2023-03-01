import 'package:app/navigation/route_paths.dart';
import 'package:app/ui_molecules/text_field/app_text_field.dart';
import 'package:app/utils/app_toast.dart';
import 'package:app/utils/stream_builder/app_stream_builder.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:statemanagement_riverpod/statemanagement_riverpod.dart';

import '../../model/resource.dart';
import 'login_view_model.dart';

class LoginPageView extends BasePageViewWidget<LoginViewModel> {
  LoginPageView(ProviderBase<LoginViewModel> model) : super(model);

  @override
  Widget build(BuildContext context, LoginViewModel model) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppTextField(
                controller: model.usernameController, nameOfField: 'Username'),
            AppTextField(
              controller: model.loginController,
              nameOfField: 'Login',
            ),
            AppStreamBuilder<Resource<QBUserEntity?>>(
              stream: model.loginResponseStream,
              initialData: Resource.none(),
              onData: (data) {
                if (data.status == Status.success) {
                  Navigator.pushReplacementNamed(context, RoutePaths.homePage);
                } else {
                  AppToast.showToast(data.dealSafeAppError?.error.message);
                }
              },
              dataBuilder: (context, data) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(45),
                        side: const BorderSide(
                          width: 1,
                        ),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      model.loginQB();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
