import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:randu_mobile/homepage/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginController extends GetxController {
  var loading = false.obs;
  var isAuth = false.obs;
  var userName = "".obs;
  var lupaLoading = false.obs;

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
    } else {
      loading(false);
      showError(body['message'].toString());
    }
  }

  void launchURL() async {
    launchUrl(Uri.parse('https://app.randu.co.id'),
        mode: LaunchMode.externalApplication);
  }

  void lupaPassword(String email) async {
    lupaLoading(true);
    var data = {"email": email};
    var res = await Network().auth(data, '/journal/lupa-password');
    var body = jsonDecode(res.body);
    if (body['success']) {
      showError(body['message'].toString());
      lupaLoading(false);
    } else {
      showError(body['message'].toString());
      lupaLoading(false);
    }
  }

  void showSuccess(String n) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(n.toString()),
    ));
  }

  void showError(String n) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(n.toString()),
    ));
  }
}
