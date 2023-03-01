import 'package:app/feature/chat_detail/chat_detail_page.dart';
import 'package:app/feature/chat_detail/chat_view_model.dart';
import 'package:app/feature/chat_list/chat_list_model.dart';
import 'package:app/feature/home_screen/home_view_model.dart';
import 'package:app/feature/login/login_view_model.dart';
import 'package:domain/domain.dart';

import 'package:flutter_errors/flutter_errors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/feature/splash/splash_page_model.dart';

import '../../dependencies.dart';

final splashViewModelProvider =
    ChangeNotifierProvider.autoDispose<SplashViewModel>(
  (ref) => SplashViewModel(
    getIt.get<AuthRepository>(),
    getIt.get<SettingsRepository>(),
    getIt.get<StorageRepository>(),
    getIt.get<FlutterExceptionHandlerBinder>(),
  ),
);

final homePageViewModelProvider =
    ChangeNotifierProvider.autoDispose<HomePageViewModel>(
        (ref) => HomePageViewModel());

final chatDetailViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<ChatDetailViewModel, ChatDetailPageArgs>(
  (ref, args) => ChatDetailViewModel(args, getIt.get<ChatRepository>(),
      getIt.get<StorageRepository>(), getIt.get<QBUserRepository>()),
);

final loginViewModelProvider =
    ChangeNotifierProvider.autoDispose<LoginViewModel>((ref) => LoginViewModel(
        getIt.get<AuthRepository>(),
        getIt.get<QBUserRepository>(),
        getIt.get<StorageRepository>()));

final chatListViewModelProvider =
    ChangeNotifierProvider.autoDispose<ChatListViewModel>((ref) =>
        ChatListViewModel(getIt.get<AuthRepository>(),
            getIt.get<StorageRepository>(), getIt.get<ChatRepository>()));
