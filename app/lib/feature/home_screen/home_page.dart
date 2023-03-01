import 'package:app/di/states/viewmodels.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:statemanagement_riverpod/statemanagement_riverpod.dart';

import 'home_page_view.dart';
import 'home_view_model.dart';

class HomePage extends BasePage<HomePageViewModel> {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends BaseStatefulPage<HomePageViewModel, HomePage>
    with SingleTickerProviderStateMixin {
  @override
  ProviderBase<HomePageViewModel> provideBase() {
    return homePageViewModelProvider;
  }

  @override
  void onModelReady(HomePageViewModel model) {
    // bind exception handler here.
    model.tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 1,
    );
  }

  @override
  bool extendBodyBehindAppBar() {
    return true;
  }

  @override
  Widget buildView(BuildContext context, HomePageViewModel model) {
    return HomePageView(provideBase());
  }
}
