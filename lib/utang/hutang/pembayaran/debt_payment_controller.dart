import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:randu_mobile/utils/ribuan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebtPaymentController extends GetxController {
  var nominalRibuan = "0".obs;
  var loading = false.obs;
  var selectedPaymentWith = "".obs;
  var currentAsset = List.empty().obs;
  var cloading = false.obs;

  void setRibuan(int value) {
    nominalRibuan.value = Ribuan.convertToIdr(value, 0);
  }

  void savePayment(int debtId, String paymentToId, String paymentFromId,
      int amount, int balance, String note, String transactionDate) async {
    loading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "tanggal": transactionDate,
        "debt_id": debtId,
        "payment_to_id": paymentToId,
        "payment_from_id": selectedPaymentWith.value,
        "amount": amount,
        "balance": balance,
        "note": note,
        "user_id": userId,
        "sync_status": 0
      };

      var res = await Network().post(data, '/journal/debt-payment');
      var body = jsonDecode(res.body);
      if (body['success']) {
        // showSuccess(body['message'].toString());
        Get.back();
        Get.back();
      } else {
        showError(body['message'].toString());
        loading(false);
      }
    }
  }

  List<DropdownMenuItem<String>> get paymentWithDropdown {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(const DropdownMenuItem(child: Text("Pilih"), value: ""));

    for (var i = 0; i < currentAsset.length; i++) {
      menuItems.add(
        DropdownMenuItem(
            child: SizedBox(
                width: MediaQuery.of(Get.context!).size.width - 85,
                child: Text(currentAsset[i]['name'].toString())),
            value: currentAsset[i]['id'].toString()),
      );
    }

    return menuItems;
  }

  void getCurrentAsset() async {
    cloading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"userid": userId};
      var res = await Network().post(data, '/journal/hutang-current-asset');
      var body = jsonDecode(res.body);
      if (body['success']) {
        currentAsset.value = body['data'];
        cloading(false);
      }
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
