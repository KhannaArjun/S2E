// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator2/login_page.dart';
import 'package:translator2/translator.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences sp = await SharedPreferences.getInstance();
  String email = sp.getString("email");
  var b = (email == null || email.isEmpty ) ?  false : true;

  runApp(MyApp(b));
}

class MyApp extends StatelessWidget
{
  bool b;
  MyApp(this.b);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
         b ? Translator('') : LoginPage(),
    );
  }

}


