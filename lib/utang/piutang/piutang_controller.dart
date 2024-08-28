import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PiutangController extends GetxController {
  var loading = false.obs;
  var piutangList = List.empty().obs;
  var now = DateTime.now();
  var formatter = DateFormat('MM');
  var formatterYear = DateFormat('yyyy');
  var thisMonth = "".obs;
  var thisYear = "".obs;
  var tahunSekarang = "".obs;
  var selectedCategory = "".obs;

  @override
  void onInit() {
    String formattedDate = formatter.format(now);
    thisMonth.value = formattedDate.toString();
    String formattedYear = formatterYear.format(now);
    thisYear.value = formattedYear.toString();
    tahunSekarang.value = formattedYear.toString();
    super.onInit();
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

  void getPiutangData(String keyword) async {
    loading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "userid": userId,
        "keyword": keyword,
        "bulan": thisMonth.value,
        "tahun": thisYear.value,
        "type": selectedCategory.value
      };

      var res = await Network().post(data, '/journal/piutang-list');
      var body = jsonDecode(res.body);
      if (body['success']) {
        piutangList.value = body['data'];
        loading(false);
      }
    }
  }

  categoryOnChange(String value) {
    selectedCategory.value = value;
    getPiutangData("");
  }

  monthOnChange(String value) {
    thisMonth.value = value;
    getPiutangData("");
  }

  yearOnChange(String value) {
    thisYear.value = value;
    getPiutangData("");
  }

  onSearchPiutang(String value) {
    getPiutangData(value);
  }

  void onPiutangDelete(int hutangId) async {
    var data = {"id": hutangId};
    var res = await Network().post(data, '/journal/piutang-destroy');
    var body = jsonDecode(res.body);
    if (body['success']) {
      Get.back();
      Get.back();
      getPiutangData("");
    }
  }

  void onPiutangSync(int hutangId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"id": hutangId, "userid": userId};
      var res = await Network().post(data, '/journal/piutang-sync');
      var body = jsonDecode(res.body);
      if (body['success']) {
        Get.back();
        Get.back();
        getPiutangData("");
      }
    }
  }
}
