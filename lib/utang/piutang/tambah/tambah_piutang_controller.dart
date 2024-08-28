import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:randu_mobile/utils/ribuan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahPiutangController extends GetxController {
  var loading = false.obs;
  var selectedCategory = "".obs;
  var selectedSub = "".obs;
  var subCategoryList = List.empty().obs;
  var piutangFrom = List.empty().obs;
  var piutangFromLoading = false.obs;
  var selectedPiutangFrom = "".obs;
  var piutangTo = List.empty().obs;
  var piutangToLoading = false.obs;
  var selectedPiutangTo = "".obs;
  var storeLoading = false.obs;
  var nominalRibuan = "0".obs;

  void getPiutangTo() async {
    piutangToLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"userid": userId};
      var res = await Network().post(data, '/journal/piutang-to');
      var body = jsonDecode(res.body);
      if (body['success']) {
        piutangToLoading(false);
        piutangTo.value = body['data'];
      }
    }
  }

  void getPiutangFrom() async {
    piutangFromLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"type": selectedCategory.value, "userid": userId};
      var res = await Network().post(data, '/journal/piutang-from');
      var body = jsonDecode(res.body);
      if (body['success']) {
        piutangFromLoading(false);
        piutangFrom.value = body['data'];
      }
    }
  }

  void getSubCategory() async {
    loading(true);
    var data = {"type": selectedCategory.value};
    var res = await Network().post(data, '/journal/piutang-sub-type');
    var body = jsonDecode(res.body);
    if (body['success']) {
      subCategoryList.value = body['data'];
      loading(false);
    }
  }

  List<DropdownMenuItem<String>> get categoryDropdown {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems
        .add(const DropdownMenuItem(child: Text("Pilih Kategori"), value: ""));

    menuItems.add(
      const DropdownMenuItem(
          child: Text("Piutang Jangka Pendek"), value: "Piutang Jangka Pendek"),
    );
    menuItems.add(
      const DropdownMenuItem(
          child: Text("Piutang Jangka Panjang"),
          value: "Piutang Jangka Panjang"),
    );

    return menuItems;
  }

  List<DropdownMenuItem<String>> get subCategoryDropdown {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(
        const DropdownMenuItem(child: Text("Pilih Sub Kategori"), value: ""));

    for (var i = 0; i < subCategoryList.length; i++) {
      menuItems.add(
        DropdownMenuItem(
            child: SizedBox(
                width: MediaQuery.of(Get.context!).size.width - 85,
                child: Text(subCategoryList[i]['name'].toString())),
            value: subCategoryList[i]['name'].toString()),
      );
    }

    return menuItems;
  }

  List<DropdownMenuItem<String>> get piutangFromDropdown {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems
        .add(const DropdownMenuItem(child: Text("Piutang Dari"), value: ""));

    for (var i = 0; i < piutangFrom.length; i++) {
      menuItems.add(
        DropdownMenuItem(
            child: SizedBox(
                width: MediaQuery.of(Get.context!).size.width - 85,
                child: Text(piutangFrom[i]['name'].toString())),
            value: piutangFrom[i]['id'].toString()),
      );
    }

    return menuItems;
  }

  List<DropdownMenuItem<String>> get piutangToDropdown {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(const DropdownMenuItem(child: Text("Simpan Ke"), value: ""));

    for (var i = 0; i < piutangTo.length; i++) {
      menuItems.add(
        DropdownMenuItem(
            child: SizedBox(
                width: MediaQuery.of(Get.context!).size.width - 85,
                child: Text(piutangTo[i]['name'].toString())),
            value: piutangTo[i]['id'].toString()),
      );
    }

    return menuItems;
  }

  void onChangeCategory(String value) {
    selectedCategory.value = value;
    selectedSub.value = "";
    getSubCategory();
    getPiutangFrom();
    getPiutangTo();
  }

  void onPiutangStore(
      String transactionName, int piutangAmount, String piutangNote) async {
    storeLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "receivable_from": selectedPiutangFrom.value,
        "save_to": selectedPiutangTo.value,
        "name": transactionName,
        "type": selectedCategory.value,
        "sub_type": selectedSub.value,
        "amount": piutangAmount,
        "note": piutangNote,
        "user_id": userId,
        "sync_status": "0",
      };

      var res = await Network().post(data, '/journal/piutang-store');
      var body = jsonDecode(res.body);
      if (body['success']) {
        showSuccess(body['message'].toString());
        storeLoading(false);
        Get.back();
      } else {
        showError(body['message'].toString());
        storeLoading(false);
      }
    }
  }

  void setRibuan(int value) {
    nominalRibuan.value = Ribuan.convertToIdr(value, 0);
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
