import 'dart:async';
import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:timer/api/my_api.dart';
import 'package:timer/globals/globals.dart' as globals;

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
  final CountDownController _controller = CountDownController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.whiteBlue,
      body: Column(
        children: [
          //windows buttons
          WindowTitleBarBox(
              child: Row(children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: globals.blue_1),
                  children: <TextSpan>[
                    const TextSpan(
                      text: "Timer: ",
                    ),
                    TextSpan(
                        text: globals.contrat_name.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Expanded(child: MoveWindow()),
            WindowButtons()
          ])),
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      //contrat name
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         globals.contrat_name.toString(),
                      //         style: TextStyle(
                      //             color: globals.black,
                      //             fontSize: 26,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox.fromSize(
                        size: const Size(262, 15),
                      ),
                      //circular timer
                      Stack(
                        children: [
                          CircularCountDownTimer(
                            duration:
                                int.parse(globals.contrat_max_time.toString()),
                            initialDuration: 0,
                            controller: _controller,
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 2.3,
                            ringColor: Colors.grey,
                            ringGradient: null,
                            fillColor: Colors.blueAccent,
                            fillGradient: null,
                            backgroundColor: globals.blue_1,
                            backgroundGradient: null,
                            strokeWidth: 20.0,
                            strokeCap: StrokeCap.butt,
                            textStyle: const TextStyle(
                                fontSize: 28.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textFormat: CountdownTextFormat.HH_MM_SS,
                            isReverse: false,
                            isReverseAnimation: false,
                            isTimerTextShown: true,
                            autoStart: false,
                            onStart: () {
                              print('Countdown Started');
                            },
                            onComplete: () {
                              print('Countdown Ended');
                              setState(() {
                                stts = false;
                                timer?.cancel();
                              });
                            },
                          ),
                          Positioned(
                              top: 69,
                              left: 31,
                              child: Text(
                                "This Month:",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: globals.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                      SizedBox.fromSize(
                        size: const Size(262, 30),
                      ),
                      //hrs and min counter
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 6.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RichText(
                                text: TextSpan(
                                  // Note: Styles for TextSpans must be explicitly defined.
                                  // Child text spans will inherit styles from parent
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                  children: <TextSpan>[
                                    const TextSpan(
                                        text: 'Today: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                      text: hrs.toString() +
                                          "Hrs " +
                                          min.toString() +
                                          "min",
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox.fromSize(),
                              //switch button
                              FlutterSwitch(
                                value: stts,
                                valueFontSize: 12.0,
                                width: 55,
                                toggleSize: 15,
                                height: 25,
                                borderRadius: 30.0,
                                showOnOff: true,
                                activeText: "ON",
                                activeColor: globals.white,
                                activeTextColor: globals.blue_1,
                                activeToggleColor: globals.blue_1,
                                inactiveText: "OFF",
                                inactiveColor: globals.blue_1,
                                inactiveTextColor: globals.white,
                                inactiveToggleColor: globals.white,
                                onToggle: (value) {
                                  setState(() {
                                    stts = value;
                                  });
                                  if (stts == true) {
                                    //Navigator.pushNamed(context, "/Timer2");
                                    _controller.resume();
                                    _selectTimeDB();
                                    timer = Timer.periodic(
                                        const Duration(seconds: 1),
                                        (Timer t) => _counter());
                                  } else {
                                    _controller.pause();
                                    _insertTimeDB(_controller.getTime());
                                    print("time: " +
                                        _controller.getTime().toString());
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
                      //app icons
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 112,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: globals.white,
                          ),
                          child: ListView(
                            children: [
                              Center(
                                child: Wrap(
                                  children: [
                                    _iconContainer("word"),
                                    _iconContainer("excel"),
                                    _iconContainer("powerPoint"),
                                    _iconContainer("access"),
                                    _iconContainer("oneNote"),
                                    _iconContainer("publisher"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SelectableLinkify(
                        text:
                            "Made by https://cretezy.com",
                      ),
                      //sizer
                      SizedBox.fromSize(
                        size: const Size(262, 200),
                      ),
                      //
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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

  _load() async {
    setState(() {
      globals.Id = const String.fromEnvironment('ID');
      globals.contrat_Id = const String.fromEnvironment('CONTRAT_ID');
      globals.contrat_name = const String.fromEnvironment('CONTRAT_NAME');
      globals.contrat_dollar_per_hour =
          const String.fromEnvironment('CONTRAT_DOLLAR_PERHOUR');
      globals.contrat_max_payment =
          const String.fromEnvironment('CONTRAT_MAX_PAYMENT');
      globals.contrat_max_time =
          (int.parse(globals.contrat_max_payment.toString()) /
                  int.parse(globals.contrat_dollar_per_hour.toString()))
              .round()
              .toString();
    });
    print(globals.Id);
    print(globals.contrat_Id);
    print(globals.contrat_name);
    print(globals.contrat_dollar_per_hour);
    print(globals.contrat_max_payment);
    print(globals.contrat_max_time);
  }
}

_iconContainer(String appName) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Tooltip(
        message: appName,
        child: Image(
          height: 40,
          width: 40,
          image: AssetImage(
            'Assets/projectLogo/${appName}Logo.png',
          ),
        ),
      ),
    ),
  );
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
_insertTimeDB(final pausedTime) async {

  var data = {
    'version': globals.version,
    'account_Id': globals.Id,
    'contrat_Id': globals.contrat_Id,
    'pausedTime':pausedTime,
  };

  var res = await CallApi().postData(data, 'Timer/Control/(Control)insertTime.php');
  print(res.body);
  List<dynamic> body = json.decode(res.body);

  if (body[0] == "success") {

  }
}

_selectTimeDB() async {

  var data = {
    'version': globals.version,
    'account_Id': globals.Id,
    'contrat_Id': globals.contrat_Id,
  };

  var res = await CallApi().postData(data, 'Timer/Control/(Control)selectTime.php');
  print(res.body);
  List<dynamic> body = json.decode(res.body);

  if (body[0] == "success") {
    //i will get hours and minutes of the contrat

  }
}