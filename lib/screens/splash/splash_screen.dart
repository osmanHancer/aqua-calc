
import 'package:aquacalc/routes.dart';
import 'package:aquacalc/screens/main/main_screen.dart';
import 'package:aquacalc/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String route = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<bool> future;

  Future<bool> initApp() async {

    
      Utils.prefs = await SharedPreferences.getInstance();

    return true;
  }

  @override
  void initState() {
    super.initState();

    future = initApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Routes.replace(MainWidget.route);
              });
            }

            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Utils.backgroundColor,
            ));
          }),
    );
  }
}
