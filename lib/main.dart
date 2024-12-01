import 'package:aquacalc/routes.dart';
import 'package:aquacalc/screens/splash/splash_screen.dart';
import 'package:aquacalc/utils/utils.dart';
import 'package:flutter/material.dart';

void main() {
  Utils.activateDarkTheme();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: SplashScreen.route,
    navigatorKey: Routes.navigatorKey,
    routes: Routes.routes
  
  ));
}
