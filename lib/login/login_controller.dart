import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:randu_mobile/homepage/homepage.dart';
import 'package:randu_mobile/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var loading = false.obs;
  var isAuth = false.obs;
  var userName = "".obs;

  void setLogin() {
    isAuth(true);
  }

  void checkLogin() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      isAuth(true);
    } else {
      isAuth(false);
    }
  }

  void login(String email, String password) async {
    loading(true);
    var data = {"email": email, "password": password};
    var res = await Network().auth(data, '/journal/login');
    var body = await jsonDecode(res.body);
    if (body['success']) {
      loading(false);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('user', json.encode(body['data']));
      localStorage.setString('token', json.encode(body['token']));
      Get.off(const HomePage());
      showToast(body['message'].toString());
    } else {
      loading(false);
      showToast(body['message'].toString());
    }
  }

  void showToast(String n) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(n.toString()),
    ));
  }
}
