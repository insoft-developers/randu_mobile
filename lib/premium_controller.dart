import 'dart:convert';

import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumController extends GetxController {
  Future cekPremium() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var userName = user['username'];
      var data = {"userid": userId, "username": userName};
      var res = await Network().post(data, '/journal/check-omset');
      var body = jsonDecode(res.body);
      if (body['success']) {
        print("lanjut");
        return true;
      } else {
        return false;
      }
    }
  }
}
