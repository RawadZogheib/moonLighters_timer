import 'dart:async';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:timer/globals/globals.dart' as globals;
import 'package:flutter_switch/flutter_switch.dart';

class MyTimer extends StatefulWidget {
  const MyTimer({Key? key}) : super(key: key);

  @override
  _MyTimerState createState() => _MyTimerState();
}

class _MyTimerState extends State<MyTimer> {
  Timer? timer;
  int hrs = 0;
  int min = 0;
  bool stts = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DesktopWindow.setWindowSize(Size(280, 460));
    DesktopWindow.setMinWindowSize(Size(280, 460));
    DesktopWindow.setMaxWindowSize(Size(280, 460));
    return Scaffold(
      backgroundColor: globals.white,
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
          Text(
            hrs.toString() + "Hrs " + min.toString() + "min " + ,
            style: TextStyle(color: globals.black, fontSize: 22),
          ),
          FlutterSwitch(
            value: stts,
            valueFontSize: 12.0,
            width: 55,
            toggleSize: 15,
            height: 25,
            borderRadius: 30.0,
            showOnOff: true,
            activeText: "ON",
            activeColor: globals.blue_2.withOpacity(0.3),
            activeTextColor: globals.blue_1,
            inactiveText: "OFF",
            inactiveColor: globals.blue_1,
            inactiveTextColor: globals.blue,
            onToggle: (value) {
              setState(() {
                stts = value;
              });
              if(value == true){
                timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _counter());
              }else{
                timer?.cancel();
                setState(() {
                  hrs = 0;
                  min = 0;
                });
              }
            },
          ),

        ]),
      ),
    );
  }

  _counter() {
    setState(() {
      if (min < 59) {
        min++;
      } else {
        hrs++;
        min = 0;
      }
    });
  }

}
