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
}
