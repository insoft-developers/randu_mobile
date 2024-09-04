import 'dart:convert';

import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengaturanController extends GetxController {
  var loading = false.obs;

  Future checkModal() async {
    loading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"userid": userId};
      var res = await Network().post(data, '/journal/modal-awal-check');
      var body = jsonDecode(res.body);
      if (body['success']) {
        return body['data'];
      }
    }
  }
}
