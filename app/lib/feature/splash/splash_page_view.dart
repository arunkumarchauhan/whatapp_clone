import 'package:app/model/resource.dart';
import 'package:app/navigation/route_paths.dart';
import 'package:app/utils/stream_builder/app_stream_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:statemanagement_riverpod/statemanagement_riverpod.dart';

import 'splash_page_model.dart';

class SplashPageView extends BasePageViewWidget<SplashViewModel> {
  SplashPageView(ProviderBase<SplashViewModel> model) : super(model);

  @override
  Widget build(BuildContext context, model) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: Colors.white,
      alignment: Alignment.center,
      child: Center(
        child: AppStreamBuilder<Status>(
            stream: model.loginResponseStream,
            initialData: Status.none,
            onData: ((value) {
              if (value == Status.success) {
                Navigator.pushReplacementNamed(context, RoutePaths.homePage);
              } else if (value == Status.error) {
                Navigator.pushReplacementNamed(context, RoutePaths.login);
              }
            }),
            dataBuilder: (context, snapshot) {
              return SizedBox(
                width: 100,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {
                    model.test();
                  },
                  child: const FlutterLogo(),
                ),
              );
            }),
      ),
    );
  }
}
