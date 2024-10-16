import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputJurnalController extends GetxController {
  var loading = false.obs;
  var accountSelect = List.empty().obs;
  var saveLoading = false.obs;

  void getAccountSelect() async {
    loading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"userid": userId};
      var res = await Network().post(data, '/journal/get-account-select');
      var body = jsonDecode(res.body);
      if (body['success']) {
        accountSelect.value = body['data'];
        loading(false);
      }
    }
  }

  List<String> get accountDropdown {
    List<String> items = [];
    for (var i = 0; i < accountSelect.length; i++) {
      items.add(accountSelect[i]['name'].toString() +
          ' ( ' +
          accountSelect[i]['group'].toString() +
          ' )');
    }

    return items;
  }

  void saveMultipleJournal(String transactionDate, String transactionName,
      List<String> akuns, List<String> debet, List<String> credit) async {
    saveLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "userid": userId,
        "transaction_date": transactionDate,
        "transaction_name": transactionName,
        "akun": akuns,
        "debit": debet,
        "kredit": credit
      };

      var res = await Network().post(data, '/journal/save-multiple-journal');
      var body = jsonDecode(res.body);
      if (body['success']) {
        saveLoading(false);
        Get.back();
      } else {
        showError(body['message'].toString());
        saveLoading(false);
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
