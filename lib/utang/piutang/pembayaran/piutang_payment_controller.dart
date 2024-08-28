import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:randu_mobile/utils/ribuan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PiutangPaymentController extends GetxController {
  var nominalRibuan = "0".obs;
  var loading = false.obs;
  var selectLoading = false.obs;
  var selectedBayarKe = "".obs;
  var selectList = List.empty().obs;

  void setRibuan(int value) {
    nominalRibuan.value = Ribuan.convertToIdr(value, 0);
  }

  void savePayment(int piutangId, String paymentFromId, int amount, int balance,
      String note) async {
    loading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "receivable_id": piutangId,
        "payment_to_id": selectedBayarKe.value,
        "payment_from_id": paymentFromId,
        "amount": amount,
        "balance": balance,
        "note": note,
        "user_id": userId,
        "sync_status": 0
      };

      var res = await Network().post(data, '/journal/piutang-payment');
      var body = jsonDecode(res.body);
      if (body['success']) {
        showSuccess(body['message'].toString());
        Get.back();
        Get.back();
      } else {
        showError(body['message'].toString());
        loading(false);
      }
    }
  }

  List<DropdownMenuItem<String>> get selectDropdown {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(const DropdownMenuItem(child: Text("Bayar Ke"), value: ""));

    for (var i = 0; i < selectList.length; i++) {
      menuItems.add(
        DropdownMenuItem(
            child: SizedBox(
                width: MediaQuery.of(Get.context!).size.width - 85,
                child: Text(selectList[i]['name'].toString())),
            value: selectList[i]['id'].toString()),
      );
    }

    return menuItems;
  }

  void piutangBayarKe() async {
    selectLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"userid": userId};
      var res = await Network().post(data, '/journal/piutang-bayar-ke');
      var body = jsonDecode(res.body);
      if (body['success']) {
        selectList.value = body['data'];
        selectLoading(false);
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
