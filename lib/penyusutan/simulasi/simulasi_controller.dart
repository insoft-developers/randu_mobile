import 'dart:convert';

import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';

class SimulasiController extends GetxController {
  var loading = false.obs;
  var simulasiList = List.empty().obs;

  void getSimulasiData(String id) async {
    loading(true);
    var data = {"id": id};
    var res = await Network().post(data, '/journal/penyusutan-simulate');
    var body = jsonDecode(res.body);
    if (body['success']) {
      loading(false);
      simulasiList.value = body['data'];
      print(simulasiList);
    }
  }
}
