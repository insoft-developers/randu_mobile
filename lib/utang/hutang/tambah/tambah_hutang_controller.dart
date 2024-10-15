import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:randu_mobile/utils/ribuan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahHutangController extends GetxController {
  var loading = false.obs;
  var selectedCategory = "".obs;
  var selectedSub = "".obs;
  var subCategoryList = List.empty().obs;
  var debtFrom = List.empty().obs;
  var debtFromLoading = false.obs;
  var selectedDebtFrom = "".obs;
  var debtTo = List.empty().obs;
  var debtToLoading = false.obs;
  var selectedDebtTo = "".obs;
  var storeLoading = false.obs;
  var nominalRibuan = "0".obs;

  void getDebtTo() async {
    debtToLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"userid": userId};
      var res = await Network().post(data, '/journal/debt-to');
      var body = jsonDecode(res.body);
      if (body['success']) {
        debtToLoading(false);
        debtTo.value = body['data'];
      }
    }
  }

  void getDebtFrom() async {
    debtFromLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"type": selectedCategory.value, "userid": userId};
      var res = await Network().post(data, '/journal/debt-from');
      var body = jsonDecode(res.body);
      if (body['success']) {
        debtFromLoading(false);
        debtFrom.value = body['data'];
      }
    }
  }

  void getSubCategory() async {
    loading(true);
    var data = {"type": selectedCategory.value};
    var res = await Network().post(data, '/journal/debt-sub-type');
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
          child: Text("Utang Jangka Pendek"), value: "Utang Jangka Pendek"),
    );
    menuItems.add(
      const DropdownMenuItem(
          child: Text("Utang Jangka Panjang"), value: "Utang Jangka Panjang"),
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

  List<DropdownMenuItem<String>> get debtFromDropdown {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(
        const DropdownMenuItem(child: Text("Pilih Utang Dari"), value: ""));

    for (var i = 0; i < debtFrom.length; i++) {
      menuItems.add(
        DropdownMenuItem(
            child: SizedBox(
                width: MediaQuery.of(Get.context!).size.width - 85,
                child: Text(debtFrom[i]['name'].toString())),
            value: debtFrom[i]['id'].toString()),
      );
    }

    return menuItems;
  }

  List<DropdownMenuItem<String>> get debtToDropdown {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems
        .add(const DropdownMenuItem(child: Text("Pilih Simpan Ke"), value: ""));

    for (var i = 0; i < debtTo.length; i++) {
      menuItems.add(
        DropdownMenuItem(
            child: SizedBox(
                width: MediaQuery.of(Get.context!).size.width - 85,
                child: Text(debtTo[i]['name'].toString())),
            value: debtTo[i]['id'].toString()),
      );
    }

    return menuItems;
  }

  void onChangeCategory(String value) {
    selectedCategory.value = value;
    selectedSub.value = "";
    getSubCategory();
    getDebtFrom();
    getDebtTo();
  }

  void onDebtStore(String transactionName, int debtAmount, String debtNote,
      String transactionDate) async {
    print(transactionDate);
    storeLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "debt_from": selectedDebtFrom.value,
        "save_to": selectedDebtTo.value,
        "name": transactionName,
        "type": selectedCategory.value,
        "sub_type": selectedSub.value,
        "amount": debtAmount,
        "note": debtNote,
        "user_id": userId,
        "sync_status": "0",
        "tanggal": transactionDate
      };

      var res = await Network().post(data, '/journal/debt-store');
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
