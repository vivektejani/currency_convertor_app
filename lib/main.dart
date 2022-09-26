
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

bool isIos = false;

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return (isIos == false)
        ? MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    )
        : CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}