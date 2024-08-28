import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';

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
      print(history);
    }
  }
}
