import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PenyusutanController extends GetxController {
  var loading = false.obs;
  var penyusutanList = List.empty().obs;
  var now = DateTime.now();
  var formatter = DateFormat('MM');
  var formatterYear = DateFormat('yyyy');
  var thisMonth = "".obs;
  var thisYear = "".obs;
  var tahunSekarang = "".obs;
  var selectedCategory = "".obs;
  var categoryList = List.empty().obs;
  var categoryLoading = false.obs;

  @override
  void onInit() {
    String formattedDate = formatter.format(now);
    thisMonth.value = formattedDate.toString();
    String formattedYear = formatterYear.format(now);
    thisYear.value = formattedYear.toString();
    tahunSekarang.value = formattedYear.toString();
    super.onInit();
  }

  void akunBiayaPenyusutan() async {
    categoryLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"userid": userId};
      var res = await Network().post(data, '/journal/akun-biaya-penyusutan');
      var body = jsonDecode(res.body);
      if (body['success']) {
        categoryList.value = body['data'];
        categoryLoading(false);
      }
    }
  }

  void getDataPenyusutan() async {
    loading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "keyword": "",
        "ml_fixed_asset": "",
        "ml_accumulated_depreciation": "",
        "ml_admin_general_fee": selectedCategory.value,
        "bulan": thisMonth.value,
        "tahun": thisYear.value,
        "userid": userId
      };
      var res = await Network().post(data, '/journal/penyusutan-list');
      var body = jsonDecode(res.body);
      if (body['success']) {
        penyusutanList.value = body['data'];
        loading(false);
      }
    }
  }

  List<DropdownMenuItem<String>> get categoryDropdown {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(const DropdownMenuItem(
        child: Text("Pilih Beban Penyusutan"), value: ""));

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

  List<DropdownMenuItem<String>> get monthDropdown {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems
        .add(const DropdownMenuItem(child: Text("Pilih Bulan"), value: ""));

    menuItems.add(
      const DropdownMenuItem(child: Text("Januari"), value: "01"),
    );
    menuItems.add(
      const DropdownMenuItem(child: Text("Febuari"), value: "02"),
    );
    menuItems.add(
      const DropdownMenuItem(child: Text("Maret"), value: "03"),
    );
    menuItems.add(
      const DropdownMenuItem(child: Text("April"), value: "04"),
    );
    menuItems.add(
      const DropdownMenuItem(child: Text("Mei"), value: "05"),
    );
    menuItems.add(
      const DropdownMenuItem(child: Text("Juni"), value: "06"),
    );
    menuItems.add(
      const DropdownMenuItem(child: Text("Juli"), value: "07"),
    );
    menuItems.add(
      const DropdownMenuItem(child: Text("Agustus"), value: "08"),
    );
    menuItems.add(
      const DropdownMenuItem(child: Text("September"), value: "09"),
    );
    menuItems.add(
      const DropdownMenuItem(child: Text("Oktober"), value: "10"),
    );
    menuItems.add(
      const DropdownMenuItem(child: Text("November"), value: "11"),
    );
    menuItems.add(
      const DropdownMenuItem(child: Text("Desember"), value: "12"),
    );

    return menuItems;
  }

  List<DropdownMenuItem<String>> get yearDropdown {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems
        .add(const DropdownMenuItem(child: Text("Pilih Tahun"), value: ""));
    int tahunIni = int.parse(tahunSekarang.value);
    for (var i = 0; i < 5; i++) {
      int tahunPilih = tahunIni - i;
      menuItems.add(
        DropdownMenuItem(
            child: Text(tahunPilih.toString()), value: tahunPilih.toString()),
      );
    }

    return menuItems;
  }

  void penyusutanDelete(int id) async {
    var data = {"id": id};
    var res = await Network().post(data, '/journal/penyusutan-delete');
    var body = jsonDecode(res.body);
    if (body['success']) {
      Get.back();
      Get.back();
      getDataPenyusutan();
    }
  }

  void penyusutanSync(int id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"id": id, "userid": userId};
      var res = await Network().post(data, '/journal/penyusutan-sync');
      var body = jsonDecode(res.body);
      if (body['success']) {
        Get.back();
        Get.back();
        getDataPenyusutan();
      }
    }
  }

  categoryOnChange(String value) {
    selectedCategory.value = value;
    getDataPenyusutan();
  }

  monthOnChange(String value) {
    thisMonth.value = value;
    getDataPenyusutan();
  }

  yearOnChange(String value) {
    thisYear.value = value;
    getDataPenyusutan();
  }

  onSearchDebt(String value) {
    getDataPenyusutan();
  }
}
