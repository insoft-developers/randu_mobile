import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:randu_mobile/utils/ribuan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebtPaymentController extends GetxController {
  var nominalRibuan = "0".obs;
  var loading = false.obs;

  void setRibuan(int value) {
    nominalRibuan.value = Ribuan.convertToIdr(value, 0);
  }

  void savePayment(int debtId, String paymentToId, String paymentFromId,
      int amount, int balance, String note) async {
    loading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "debt_id": debtId,
        "payment_to_id": paymentToId,
        "payment_from_id": paymentFromId,
        "amount": amount,
        "balance": balance,
        "note": note,
        "user_id": userId,
        "sync_status": 0
      };

      var res = await Network().post(data, '/journal/debt-payment');
      var body = jsonDecode(res.body);
      if (body['success']) {
        showSuccess(body['message'].toString());
      } else {
        showError(body['message'].toString());
        loading(false);
      }
    }
  }

  void showError(String n) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Html(
        data: n,
        defaultTextStyle: const TextStyle(
            color: Colors.white, fontFamily: 'Rubik', fontSize: 14),
      ),
    ));
  }

  void showSuccess(String n) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      backgroundColor: Colors.green[900],
      content: Html(
        data: n,
        defaultTextStyle: const TextStyle(
            color: Colors.white, fontFamily: 'Rubik', fontSize: 14),
      ),
    ));
  }
}
