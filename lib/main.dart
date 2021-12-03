import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:timer/page/timer.dart';

void main() {
  debugShowCheckedModeBanner: false;
  runApp(MyApp());
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
