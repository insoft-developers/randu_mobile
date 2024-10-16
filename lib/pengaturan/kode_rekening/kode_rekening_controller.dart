import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KodeRekeningController extends GetxController {
  var loading = false.obs;
  var accountSelect = List.empty().obs;
  var accountGroup = List.empty().obs;
  var kodeLoading = false.obs;
  var kodeList = List.empty().obs;
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
        accountGroup.value = body['group'];
        loading(false);
      }
    }
  }

  Future getDetail(int index) async {
    kodeLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"userid": userId, "account": index};
      var res =
          await Network().post(data, '/journal/pengaturan-rekening-detail');
      var body = jsonDecode(res.body);
      if (body['success']) {
        kodeLoading(false);
        kodeList.value = body['data'];
        print(body);
      }
    }
  }

  void save(int indexId, List<String> accountItem, List<String> id,
      int accountCodeId) async {
    saveLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "userid": userId,
        "index_id": indexId,
        "account_item": accountItem,
        "account_code_id": accountCodeId + 1,
        "id": id
      };
      var res = await Network().post(data, '/journal/pengaturan-rekening-save');
      var body = jsonDecode(res.body);
      if (body['success']) {
        saveLoading(false);
        showSuccess(body['message'].toString());
      } else {
        showError(body['message'].toString());
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
