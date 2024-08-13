import 'dart:convert';

import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:randu_mobile/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageController extends GetxController {
  var branchName = "".obs;
  var tabIndex = 0.obs;

  void changeTabIndex(int tab) {
    tabIndex.value = tab;
  }

  void getBranchName() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"userid": userId};
      var res = await Network().post(data, '/journal/branch-name');
      var body = jsonDecode(res.body);
      if (body['success']) {
        branchName.value = body['data'];
      }
    }
  }

  void logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      localStorage.remove('user');
      localStorage.remove('token');
      Get.offAll(() => const LoginPage());
    }
  }
}
