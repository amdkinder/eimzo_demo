import 'dart:developer';

import 'package:eimzo_demo/crypto_non_null/gost_hash.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'crc32.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _launchEimzo() async {
    var qrcode = makeHashQR();
    var _deepLink = 'eimzo://sign?qc=$qrcode';
    var result = await launchUrlString(_deepLink);
    log("result: $result");
  }

  String makeHashQR() {
    var siteId = "860b";
    var docId = "N4DWHMUM";
    var challenge =
        "I9BV1HBL7JZRSNN81X3XES1HRC9YLECS9N4DWHMUMHLTYYNUGL11ZX1M57JT7YOI";
    var textHash = GostHash.hashGost(challenge);
    var code = siteId + docId + GostHash.hashGost(challenge);
    var crc32 = Crc32.calcHex(code);
    code += crc32;
    return code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _launchEimzo,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
