import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_app/fire_base/shared_preferences.dart';
import 'package:project_app/models/user.dart';
import 'package:project_app/screens/common_layout.dart';
import 'package:project_app/screens/home.dart';
import 'package:project_app/screens/sign_up.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  isLoginFunc() async {
    try{
     UserModel? user = await SharedPreferencesController.getUserInfo();
    if (user != null) {
      log(user.toJson().toString());
      setState(() {
        isLogin = true;
      });
    } else {
      log("user not logIn");
    }
    }catch(e){
      log(e.toString());
    }
    
  }

  @override
  void initState() {
    isLoginFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Region & Category Display App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.teal),
        fontFamily: 'Roboto',
      ),
      home: CommonLayout(
        title: 'Explore Places',
        description: 'Discover amazing regions and categories',
        onPressed: () {},
        destinationPage: isLogin?HomePage():const SignUpPage(), // Spécifiez votre page de destination réelle
      ),
    );
  }
}
