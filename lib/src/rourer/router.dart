import 'package:flutter/cupertino.dart';
import 'package:qwe/src/rourer/router_const.dart';
import 'package:qwe/src/screens/chat/chat_screen.dart';
import 'package:qwe/src/screens/main/main_screen.dart';
import 'package:qwe/src/screens/settings/setting_screen.dart';

class AppRouter {
  static Route generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case MainRoute:
        return CupertinoPageRoute(builder: (context) => const MainScreen());
      case ChatRoute:
        return CupertinoPageRoute(builder: (context) =>  ChatScreen());
      case SettingRoute:
        return CupertinoPageRoute(builder: (context) => const SettingsScreen());
      default:
        return CupertinoPageRoute(builder: (context) => const MainScreen());
    }
  }
}
