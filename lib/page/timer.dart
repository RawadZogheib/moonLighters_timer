import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:async/async.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:process_run/shell.dart';
import 'package:timer/api/my_api.dart';
import 'package:timer/globals/globals.dart' as globals;

import '../api/my_api.dart';

var shell = Shell();
String data = "";
class MyTimer extends StatefulWidget {
  String folderSS = 'Screenshots';
  String? folderContratId = globals.contrat_Id;

  @override
  _MyTimerState createState() => _MyTimerState();
}

class _MyTimerState extends State<MyTimer> {
  Timer? timer;
  Timer? timer2;
  Timer? timer3;
  Timer? timerInit;
  int hrs = 0;
  int min = 0;
  int initialValue = 0;
  bool stts = false;
  bool counterOn = false;
  bool load = true;
  late CountDownController _controller;

  @override
  void initState() {
    super.initState();

    //timerInit = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      _load();
      // await _selectTimeDB();
      // _controller = CountDownController();
      // //timerInit?.cancel();
      // _controller.pause();
    //});
    _activeApps();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    timer2?.cancel();
    timer3?.cancel();
    timerInit?.cancel();
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
                      load==false?Stack(
                        children: [
                          CircularCountDownTimer(
                            duration:
                                int.parse(globals.contrat_max_time.toString()),
                            initialDuration: initialValue,
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
                            autoStart: true,
                            onStart: () {
                              print('Countdown Started');
                            },
                            onComplete: () {
                                print('Countdown Ended');
                                setState(() {
                                  stts = false;
                                  timer?.cancel();
                                  timer2?.cancel();
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
                      ):Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 2.3,
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
                                    print("jojdsoijoijoisjgoijreiojhotjh"+initialValue.toString());

                                    timer = Timer.periodic(
                                        const Duration(seconds: 1),
                                        (Timer t) => _counter());
                                    counterOn = true;
                                    if (timer2 == null) {
                                      print("counter null");
                                      _counter2();
                                      print("counter null finished");
                                    }
                                    timer2 = Timer.periodic(
                                        const Duration(minutes: 1),
                                        (Timer t) => _counter2());
                                    //_setTimer();
                                  } else {
                                    _controller.pause();
                                    _insertTimeDB(_controller.getTime());
                                    print("time: " +
                                        _controller.getTime().toString());
                                    timer?.cancel();
                                    counterOn = false;
                                    timer2?.cancel();
                                    timer2 = null;
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
                        text: "Made by https://cretezy.com",
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

  _counter2() async {
    print('counter2 started!!');
    await Future.delayed(Duration(seconds: Random().nextInt(30)));
    if (counterOn == true) {
      _createFolders();
    }
    await Future.delayed(const Duration(seconds: 1));
    await Future.delayed(Duration(seconds: Random().nextInt(29)));
    if (counterOn == true) {
      _createFolders();
    }
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

    await _selectTimeDB();
    _controller = CountDownController();
    //timerInit?.cancel();
    timerInit = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      timerInit?.cancel();
      _controller.pause();
      print("sfyaufdhsfggsdfgc");
    });
    setState(() {
      load = false;
    });
  }

  _createFolders() async {
    print("${widget.folderContratId} is the contrat id");

    // var data = {
    //   'version': globals.version,
    //   'folderSS': folderSS,
    //   'folderContrat': folderContrat
    // };
    //
    // var res =
    //     await CallApi().postData(data, 'Screenshot/Control/(Control)createFolders.php');
    // print(res);
    // print(res.body);
    // //print("pppppp");
    // List<dynamic> body = json.decode(res.body);

    if (Platform.isWindows) {
      bool directoryExists = await Directory(widget.folderSS).exists();
      bool contratExists =
          await Directory('${widget.folderSS}/${widget.folderContratId}')
              .exists();
      Directory dirContrat =
          await Directory('${widget.folderSS}/${widget.folderContratId}');

      if (!directoryExists) {
        // do stuff
        await shell.run('''mkdir ${widget.folderSS}''');
      }
      if (!contratExists) {
        dirContrat.create();
      }
    } else if (Platform.isMacOS || Platform.isLinux) {
      // Word Documents
      bool directoryExists = await Directory(widget.folderSS).exists();
      bool contratExists =
          await Directory('${widget.folderSS}/${widget.folderContratId}')
              .exists();
      Directory dirContrat =
          await Directory('${widget.folderSS}/${widget.folderContratId}');

      if (!directoryExists) {
        // do stuff
        await shell.run('''mkdir ${widget.folderSS}''');
      }
      if (!contratExists) {
        dirContrat.create();
      }
    }

    _takeScreenshot();
  }

  _takeScreenshot() async {
    // bool directryExists = await Directory(widget.folderSS).exists();
    // if (!directryExists) {
    //   // do stuff
    //   await shell.run('''mkdir ${widget.folderSS}''');
    // }

    String dateSS = 'ScreenShot' +
        DateTime.now().year.toString() +
        '-' +
        DateTime.now().month.toString() +
        '-' +
        DateTime.now().day.toString() +
        '-' +
        DateTime.now().hour.toString() +
        '-' +
        DateTime.now().minute.toString() +
        '-' +
        DateTime.now().second.toString();

    await shell.run(
        '''Nircmd.exe savescreenshot "./${widget.folderSS}/${widget.folderContratId}/${dateSS}.jpg"''');
    String pathSS = await Directory(
            './${widget.folderSS}/${widget.folderContratId}/${dateSS}.jpg')
        .path;
    print(pathSS);

    uploadFile('file', File('${pathSS}'));

    var data = {
      'version': globals.version,
      'contrat_Id': widget.folderContratId,
      'screenshot_Id': dateSS,
    };

    var res = await CallApi()
        .postData(data, 'Screenshot/Control/(Control)sendScreenshotToDB.php');
    print(res);
    print(res.body);
    //print("pppppp");
    List<dynamic> body = json.decode(res.body);

    if (body[0] == "true") {
    } else if (body[0] == "error7") {}
  }

  uploadFile(String title, File file) async {
    //edit
// open a bytestream
    var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    print('$length iutiug');
    // var uri = Uri.parse(
    //     "${globals.myIP}/Screenshot/Control/(Control)sendScreenshotToServer.php");
    // var request = new http.MultipartRequest("POST", uri);
    // var multipartFile = new http.MultipartFile('file', stream, length,
    //     filename: basename(file.path));
    var request = await CallApi().uploadScreenshot();

    var multipartFile = new http.MultipartFile(title, stream, length,
        filename: basename(file.path));

    request.fields["version"] = globals.version;
    request.fields["contratId"] = globals.contrat_Id;
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  // _setTimer() {
  //   timer2 = Timer.periodic(const Duration(seconds: 20), (Timer t) {
  //     print("20sec gone!!");
  //     if (mounted) {
  //       print("20sec gone,and _takeScreenshot!!");
  //       _createFolders();
  //
  //       //_loadTables();
  //     }
  //   });
  // }
  _loadActiveApps() async {
    await shell.run('''activeApps/flutter_sys.bat''');
    _readData("activeApps/listword.txt", "1", false); //word
    _readData("activeApps/listexcel.txt", "2", false); //excel
    _readData("activeApps/listpowerpoint.txt", "3", false); //powerpoint
    _readData("activeApps/listchrome.txt", "7", false); //chrome
    _readData("activeApps/listcode.txt", "8", false); //code
    _readData("activeApps/listteams.txt", "9", false); //teams
    _readData("activeApps/liststudio.txt", "10", true); //studio
  }

  _readData(String listApp, String typeApp, bool prnt) {
    int i = 0;

    new File(listApp)
        .openRead()
        .transform(utf8.decoder)
        .transform(new LineSplitter())
        .forEach((l) {
      if (l ==
          "INFO: No tasks are running which match the specified criteria.") {
        globals.map_activeApps.addAll({typeApp: "Offline"});

      } else {
        i = i + 1;
        if (i == 10) {
          data = l.substring(14);

          globals.map_activeApps.addAll({typeApp: data});
          //printyy();

        }
      }
      //printyy();
    }).then((value) => {
      if(prnt == true){
        printyy(),
        //_insertActiveAppsDB()
      }
    });

  }

  printyy() {
    print(globals.map_activeApps.toString());
    setState(() {
      globals.map_activeApps.toString();
    });

  }
  _insertActiveAppsDB() async {
    var data = {
      'version': globals.version,
      'account_Id': globals.Id,
      'contrat_Id': globals.contrat_Id,
      'map_activeApps': globals.map_activeApps
    };

    var res =
    await CallApi().postData(data, 'Timer/Control/(Control)insertActiveApps.php');
    print(res.body);
    List<dynamic> body = json.decode(res.body);

    if (body[0] == "success") {
    }
  }

  _activeApps() {
    _loadActiveApps();

    timer3 = Timer.periodic(const Duration(seconds: 30), (Timer t) {
      print("30sec gone!!");
      if (mounted) {
        print("30sec gone,and _loadChildrenOnline!!");
        _loadActiveApps();
      }
    });
  }
  _selectTimeDB() async {
    var data = {
      'version': globals.version,
      'account_Id': globals.Id,
      'contrat_Id': globals.contrat_Id,
    };

    var res = await CallApi().postData(data, 'Timer/Control/(Control)selectTime.php');
    print("selectTimeDB"+res.body);
    List<dynamic> body = json.decode(res.body);
    if (body[0] == "success") {
      print(body[1]);
      //i will get total seconds of the contrat
      setState(() {
        initialValue = int.parse(body[1].toString());
        //_controller.restart();
      });


        //load = false;


    }
  }
  _insertTimeDB(final pausedTime) async {
    var data = {
      'version': globals.version,
      'account_Id': globals.Id,
      'contrat_Id': globals.contrat_Id,
      'pausedTime': pausedTime,
    };
  print("AAAAAAWDJEUYYRU4YTUIY4TUY4T"+pausedTime);
    var res =
    await CallApi().postData(data, 'Timer/Control/(Control)insertTime.php');
    print(res.body);
    List<dynamic> body = json.decode(res.body);

    if (body[0] == "success") {
    }
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




