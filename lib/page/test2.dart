




import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:process_run/shell.dart';
var shell = Shell();


class MyHomePage extends StatefulWidget {

  String pp = "Screenshots";



  //final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //final controller = ScreenshotController();

  ScreenshotController screenshotController = ScreenshotController();

  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("kaidhalsd"),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'This screen is being captured',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          //screenshotController.capture().then((Uint8List? image) async{
            // final directory = (await getApplicationDocumentsDirectory ()).path; //from path_provide package
            // String fileName = 'qwe';
            // var path = '$directory';


            // final directory = (await getApplicationDocumentsDirectory ()).path;
            // print('directory: ' + directory.toString());
            //String directory = 'D:/GitHub/moonLighters/moonLighters_timer/$pp'; //from path_provide package

            bool directoryExists = await Directory(widget.pp).exists();
            // Directory pathSS = Directory(
            //     'D:/GitHub/moonLighters/moonLighters_timer/$pp');
            print("aaaaaaaaaaaaaaaa");
            // if ((!await directory.exists())) {
            //   directory.create();
            // }
            if (!directoryExists) {
              print("sdvsdvsdvsdv");
              // do stuff
              await shell.run('''mkdir ${widget.pp}''');
            }

            //await shell.run('''cd /''');
            //await shell.run('''cd C:/Windows/System32''');
            //await shell.run('''call nircmd''');
            await shell.run('''Nircmd.exe savescreenshot "./${widget.pp}/Screen.jpg"''');

          //   String fileName = '12';
          //   var path = '$directory';
          //
          //   screenshotController.captureAndSave(
          //   path, //set path where screenshot will be saved
          //   fileName:fileName
          //   );
          // }).catchError((onError) {
          //   print(onError);
          // });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.screenshot),
      ),
    );
  }
}
