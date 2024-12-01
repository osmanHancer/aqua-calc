import 'package:aquacalc/screens/cable/cable_cost_screen.dart';
import 'package:aquacalc/screens/efficiency/eff_screen.dart';
import 'package:aquacalc/screens/friction/friction_screen.dart';
import 'package:aquacalc/screens/main/main_screen.dart';
import 'package:aquacalc/screens/splash/splash_screen.dart';
import 'package:aquacalc/screens/torque/torque_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Map<String, Widget Function(BuildContext)> routes = {
    SplashScreen.route: (context) => const SplashScreen(),
    MainWidget.route: (context) => const MainWidget(),
    EffScreen.route: (context) => const EffScreen(),
    FrictionLoss.route: (context) => const FrictionLoss(),
    CableLost.route: (context) => const CableLost(),
    TorqueScreen.route: (context) => const TorqueScreen(),
  };

  static Future<dynamic> push(routePath, {dynamic arg}) {
    return navigatorKey.currentState!.pushNamed(routePath, arguments: arg);
  }

  static Future<dynamic> replace(routePath, {dynamic arg}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routePath, arguments: arg);
  }

  static void pop({dynamic data}) {
    navigatorKey.currentState!.pop(data);
  }

  static void popAll({force = false}) {
    while (navigatorKey.currentState!.canPop()) {
      pop();
    }
    if (force) pop();
  }
}
