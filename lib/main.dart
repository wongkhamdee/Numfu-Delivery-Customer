import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:numfu/main_page.dart';
import 'package:numfu/screen/Launcher.dart';
import 'package:numfu/screen/edit_user.dart';
import 'package:numfu/screen/index.dart';
import 'package:numfu/screen/login.dart';
import 'package:numfu/utility/app_controller.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

final Map<String, WidgetBuilder> map = {
  '/login': (BuildContext Context) => Login(),
  '/Launcher': (BuildContext Context) => Launcher(),
  '/EditProfile': (BuildContext Context) => EditProfile(),
};

String? initlalRoute;

Future main() async {
  HttpOverrides.global = MyHttpOverride();

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var datas = preferences.getStringList('datas');

  print('## datas at main ---> $datas');
  await initializeDateFormatting('th_TH', null);
  if (datas == null) {
    initlalRoute = '/login';
    runApp(const MyApp());
  } else {
    AppController appController = Get.put(AppController());
    appController.datas.addAll(datas);

    initlalRoute = '/Launcher';
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      //debugShowCheckedModeBanner: false,
      debugShowCheckedModeBanner: false,
      title: MyCostant.appName,
      routes: map,
      initialRoute: initlalRoute,
      theme: ThemeData(
        fontFamily: 'MN',
        primarySwatch: Colors.orange,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
