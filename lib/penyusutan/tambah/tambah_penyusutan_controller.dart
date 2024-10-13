import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:randu_mobile/utils/ribuan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahPenyusutanController extends GetxController {
  var loading = false.obs;
  var selectedKategori = "".obs;
  var categoryList = List.empty().obs;
  var categoryLoading = false.obs;
  var akumulasiLoading = false.obs;
  var akumulasiList = List.empty().obs;
  var selectedAkumulasi = "".obs;
  var bebanList = List.empty().obs;
  var bebanLoading = false.obs;
  var selectedBeban = "".obs;
  var nilaiAwalRibuan = "0".obs;
  var nilaiResiduRibuan = "0".obs;

  void setAwalRibuan(int value) {
    nilaiAwalRibuan.value = Ribuan.convertToIdr(value, 0);
  }

  void setResiduRibuan(int value) {
    nilaiResiduRibuan.value = Ribuan.convertToIdr(value, 0);
  }

  void onCategoryChange(String value) {
    selectedKategori.value = value;
  }

  void penyusutanStore(
      String name, int initialValue, int usefulLife, int residu) async {
    loading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "ml_fixed_asset_id": selectedKategori.value,
        "ml_accumulated_depreciation_id": selectedAkumulasi.value,
        "ml_admin_general_fee_id": selectedBeban.value,
        "name": name,
        "initial_value": initialValue,
        "useful_life": usefulLife,
        "residual_value": residu,
        "user_id": userId
      };
      var res = await Network().post(data, '/journal/penyusutan-store');
      var body = jsonDecode(res.body);
      if (body['success']) {
        loading(false);
        Get.back();
      } else {
        loading(false);
        showError(body['message'].toString());
      }
    }
  }

  void getPenyusutanCategory() async {
    categoryLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"userid": userId};
      var res = await Network().post(data, '/journal/kategori-penyusutan');
      var body = jsonDecode(res.body);
      if (body['success']) {
        categoryList.value = body['data'];
        categoryLoading(false);
      }
    }
  }

  void getBebanPenyusutanData() async {
    bebanLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"userid": userId};
      var res = await Network().post(data, '/journal/akun-biaya-penyusutan');
      var body = jsonDecode(res.body);
      if (body['success']) {
        bebanList.value = body['data'];
        bebanLoading(false);
      }
    }
  }

  void getAkumulasiData() async {
    akumulasiLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"userid": userId, "keyword": ""};
      var res =
          await Network().post(data, '/journal/akun-akumulasi-penyusutan');
      var body = jsonDecode(res.body);
      if (body['success']) {
        akumulasiList.value = body['data'];
        akumulasiLoading(false);
      }
    }
  }

  List<DropdownMenuItem<String>> get categoryDropdown {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems
        .add(const DropdownMenuItem(child: Text("Pilih Kategori"), value: ""));

    for (var i = 0; i < categoryList.length; i++) {
      menuItems.add(
        DropdownMenuItem(
            child: SizedBox(
                width: MediaQuery.of(Get.context!).size.width - 85,
                child: Text(categoryList[i]['name'].toString())),
            value: categoryList[i]['id'].toString()),
      );
    }

    return menuItems;
  }

  List<DropdownMenuItem<String>> get akumulasiDropdown {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(const DropdownMenuItem(
        child: Text("Pilih Akumulasi Penyusutan"), value: ""));

    for (var i = 0; i < akumulasiList.length; i++) {
      menuItems.add(
        DropdownMenuItem(
            child: SizedBox(
                width: MediaQuery.of(Get.context!).size.width - 85,
                child: Text(akumulasiList[i]['name'].toString())),
            value: akumulasiList[i]['id'].toString()),
      );
    }

    return menuItems;
  }

  List<DropdownMenuItem<String>> get bebanDropdown {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(const DropdownMenuItem(
        child: Text("Pilih Beban Penyusutan"), value: ""));

    for (var i = 0; i < bebanList.length; i++) {
      menuItems.add(
        DropdownMenuItem(
            child: SizedBox(
                width: MediaQuery.of(Get.context!).size.width - 85,
                child: Text(bebanList[i]['name'].toString())),
            value: bebanList[i]['id'].toString()),
      );
    }

    return menuItems;
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
