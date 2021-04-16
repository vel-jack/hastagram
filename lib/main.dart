import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hastagram/model/post_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'ui/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Box _box = await Hive.openBox('hashtags');
  print(_box.keys);
  Hive.registerAdapter(InstaPostAdapter());
  await Hive.openBox<InstaPost>('savedpost');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Box _hastags = Hive.box('hashtags');
  List<String> _suggestedTags = [
    'cats',
    'dogs',
    'funny',
    'love',
    'food',
    'style'
  ];
  Random r = new Random();
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    if (_hastags.isEmpty) {
      String key = _suggestedTags[r.nextInt(_suggestedTags.length)];
      _hastags.put(key, key);
      print('adf');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(primaryColor: Colors.white),
    );
  }
}
