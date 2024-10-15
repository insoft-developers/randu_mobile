import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PiutangHistoryController extends GetxController {
  var loading = false.obs;
  var history = List.empty().obs;

  void getHistoryById(String id) async {
    loading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"id": id, "userid": userId};
      var res = await Network().post(data, '/journal/piutang-history');
      var body = jsonDecode(res.body);
      if (body['success']) {
        history.value = body['data'];
        loading(false);
      } else {
        showError(body['message'].toString());
        loading(false);
      }
    }
  }

  void paymentSync(String paymentId, String hutangId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"payment_id": paymentId, "userid": userId};

      var res = await Network().post(data, '/journal/piutang-payment-sync');
      var body = jsonDecode(res.body);
      if (body['success']) {
        Get.back();
        getHistoryById(hutangId);
      }
    }
  }

  void showError(String n) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Html(
        data: n,
        // defaultTextStyle: const TextStyle(
        //     color: Colors.white, fontFamily: 'Rubik', fontSize: 14),
      ),
    ));
  }
}
