import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:medpiper/home.dart';
import 'package:medpiper/login.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final dbDir = await getApplicationDocumentsDirectory();
  Hive.init(dbDir.path);
  var box = await Hive.openBox('user');
  String userPhone = box.get('phone', defaultValue: 'empty');
  runApp(MyApp(
    phone: userPhone,
  ));
}

class MyApp extends StatelessWidget {
  String phone;
  MyApp({Key? key, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MedPiper",
      home: phone == 'empty'
          ? const Login()
          : Home(number: phone, isFromLogin: false),
    );
  }
}
