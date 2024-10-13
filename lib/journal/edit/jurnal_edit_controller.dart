import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalEditController extends GetxController {
  var loading = false.obs;
  var accountSelect = List.empty().obs;
  var saveLoading = false.obs;
  var journal = <String, dynamic>{}.obs;
  var journalList = List.empty().obs;
  var journalLoading = false.obs;
  var journalDate = "".obs;

  Future getDataJournal(String id) async {
    journalLoading(true);
    var data = {"id": id};
    var res = await Network().post(data, '/journal/journal-edit');
    var body = jsonDecode(res.body);
    if (body['success']) {
      journalLoading(false);
      journal.value = body['data']['jurnal'];
      journalList.value = body['data']['list'];
      journalDate.value = body['data']['tanggal'];
      print(body);
    }
  }

  Future getAccountSelect() async {
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
      // items.add(accountSelect[i]['name'].toString());
    }

    return items;
  }

  void updateMultipleJournal(
      int transactionId,
      String transactionDate,
      String transactionName,
      List<String> akuns,
      List<String> debet,
      List<String> credit) async {
    saveLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "transaction_id": transactionId,
        "userid": userId,
        "transaction_date": transactionDate,
        "transaction_name": transactionName,
        "akun": akuns,
        "debit": debet,
        "kredit": credit
      };

      var res = await Network().post(data, '/journal/update-multiple-journal');
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

  void showSuccess(String n) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      backgroundColor: Colors.green[900],
      content: Html(
        data: n,
        // defaultTextStyle: const TextStyle(
        //     color: Colors.white, fontFamily: 'Rubik', fontSize: 14),
      ),
    ));
  }
}
