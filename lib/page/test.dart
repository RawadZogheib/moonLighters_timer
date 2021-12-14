import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer/page/timer.dart';
import 'package:timer/globals/globals.dart' as globals;


class MyHomePage2 extends StatefulWidget {

  @override
  State<MyHomePage2> createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {
  int _countcer = 0;

  Future<void> _incrementCounter() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('token', (_countcer++).toString());
    var token = localStorage.getString('token');
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.whiteBlue,
      body: Column(
        children: [
          WindowTitleBarBox(
              child: Row(children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text("Timer",style: TextStyle(color: Colors.black),),
                ),
                Expanded(child: MoveWindow()),
                WindowButtons()
              ])),
          Text(
            'You have pushed the button this many times:',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}
final buttonColors = WindowButtonColors(
    iconNormal: globals.blue_1,
    mouseOver: globals.blue_1,
    mouseDown: globals.blue_1,
    iconMouseOver: globals.white,
    iconMouseDown: globals.white);

final closeButtonColors = WindowButtonColors(
    iconNormal: globals.blue_1,
    mouseOver: globals.blue_1,
    mouseDown: globals.blue_1,
    iconMouseOver: globals.white);

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        //MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}