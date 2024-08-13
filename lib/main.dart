import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/homepage/homepage.dart';
import 'package:randu_mobile/login/login_controller.dart';
import 'package:randu_mobile/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(const GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LoginController _loginController = Get.put(LoginController());

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      if (mounted) {
        _loginController.setLogin();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() =>
          _loginController.isAuth.value ? const HomePage() : const LoginPage()),
    );
  }
}
