/** author: pidwid
    github: github.com/pidwid **/

/** for : TOPIC HERE**/

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Scanner',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  QRViewController controller;
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  var flashState = false;

  void _toggleflash() {
    flashState = !flashState;
    this.controller?.toggleFlash();
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: flashState == true ? Text("Flash on") : Text("Flash off"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  setState(() {
                    qrText = scanData;
                  });
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              child: Column(
                children: <Widget>[
                  Card(
                    color: Colors.yellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.switch_camera),
                            onPressed: () {
                              this.controller?.flipCamera();
                              _scaffoldkey.currentState
                                  .showSnackBar(new SnackBar(
                                content: Text("Camera rotated"),
                              ));
                            }),
                        IconButton(
                            icon: Icon(
                                flashState ? Icons.flash_on : Icons.flash_off),
                            onPressed: () {
                              setState(() {
                                _toggleflash();
                              });
                            }),
                        IconButton(
                            icon: Icon(Icons.content_copy),
                            onPressed: () {
                              Clipboard.setData(
                                  new ClipboardData(text: qrText));
                              _scaffoldkey.currentState
                                  .showSnackBar(new SnackBar(
                                content: qrText != ""
                                    ? Text("Copied to Clipboard")
                                    : Text("Please scan a QR first"),
                              ));
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SelectableText(
                        qrText,
                        maxLines: 5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
