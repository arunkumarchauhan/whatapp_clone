import 'package:app/feature/chat_detail/chat_detail_page.dart';
import 'package:app/feature/chat_list/chat_list_page.dart';
import 'package:app/feature/home_screen/home_page.dart';
import 'package:app/feature/login/login_page.dart';

import 'package:flutter/cupertino.dart';

import '../feature/splash/splash_page.dart';
import 'route_paths.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.splash:
        return CupertinoPageRoute(
            builder: (context) => const SplashPage(),
            settings: const RouteSettings(name: RoutePaths.splash));

      case RoutePaths.homePage:
        return CupertinoPageRoute(
            builder: (context) => const HomePage(),
            settings: const RouteSettings(name: RoutePaths.homePage));
      case RoutePaths.chatDetail:
        return CupertinoPageRoute(
            builder: (context) =>
                ChatDetailPage(args: settings.arguments as ChatDetailPageArgs),
            settings: const RouteSettings(name: RoutePaths.chatDetail));
      case RoutePaths.login:
        return CupertinoPageRoute(
            builder: (context) => const LoginPage(),
            settings: const RouteSettings(name: RoutePaths.login));
      case RoutePaths.chatList:
        return CupertinoPageRoute(
            builder: (context) => const ChatListPage(),
            settings: const RouteSettings(name: RoutePaths.chatList));

      default:
        // Replace by Empty Page
        return CupertinoPageRoute(
          builder: (context) => Container(),
        );
    }
  }
}
