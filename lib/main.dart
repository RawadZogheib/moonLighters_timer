import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:timer/page/timer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DesktopWindow.setWindowSize(const Size(280, 460));
  DesktopWindow.setMinWindowSize(const Size(280, 460));
  DesktopWindow.setMaxWindowSize(const Size(280, 460));
  debugShowCheckedModeBanner: false;
  _saveSharedPreferences(const String.fromEnvironment('ID'));
  runApp(MyApp());
}

_saveSharedPreferences(String id) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  localStorage.setString('Id', id);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          //home: FirstPage(),
          initialRoute: '/Timer',
          routes: {
            '/Timer': (context) => MyTimer(),
          });
    });
  }
}
