import 'dart:convert';

import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebtHistoryController extends GetxController {
  var loading = false.obs;
  var history = List.empty().obs;

  void getHistoryById(String id) async {
    loading(true);
    var data = {"id": id};
    var res = await Network().post(data, '/journal/debt-history');
    var body = jsonDecode(res.body);
    if (body['success']) {
      history.value = body['data'];
      loading(false);
    }
  }

  void paymentSync(String paymentId, String hutangId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"payment_id": paymentId, "userid": userId};

      var res = await Network().post(data, '/journal/payment-sync');
      var body = jsonDecode(res.body);
      if (body['success']) {
        Get.back();
        getHistoryById(hutangId);
      }
    }
  }
}
