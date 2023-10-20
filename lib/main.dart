import 'dart:convert';

import 'package:coin_cap_app/Views/Home_Page/home_page.dart';
import 'package:coin_cap_app/models/app_config.dart';
import 'package:coin_cap_app/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfig();
  registerHTTPService();
  runApp(MyApp());
}

Future<void> loadConfig() async {
  String _configContent =
      await rootBundle.loadString("assets/config/main.json");

  Map _configData = jsonDecode(_configContent);

  GetIt.instance.registerSingleton<AppConfig>(
    AppConfig(
      COIN_API_BASE_URL: _configData["COIN_API_BASE_URL"],
    ),
  );
}

void registerHTTPService() {
  GetIt.instance.registerSingleton<HTTPService>(
    HTTPService(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Coin Cap',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Color.fromRGBO(88, 60, 197, 1.0)),
          home: HomePage(),
        );
      },
    );
  }
}
