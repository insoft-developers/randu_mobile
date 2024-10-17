import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:randu_mobile/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NeracaController extends GetxController {
  var loading = false.obs;
  var now = DateTime.now();
  var formatter = DateFormat('MM');
  var formatterYear = DateFormat('yyyy');
  var thisMonth = "".obs;
  var thisYear = "".obs;
  var tahunSekarang = "".obs;
  var neracaList = List.empty().obs;

  @override
  void onInit() {
    String formattedDate = formatter.format(now);
    thisMonth.value = formattedDate.toString();
    String formattedYear = formatterYear.format(now);
    thisYear.value = formattedYear.toString();
    tahunSekarang.value = formattedYear.toString();
    super.onInit();
  }

  void getNeracaSaldo() {}

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

  void getNeraca() async {
    loading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "userid": userId,
        "month_from": thisMonth.value,
        "year_from": thisYear.value
      };

      var res = await Network().post(data, '/journal/balance-sheet');
      var body = jsonDecode(res.body);
      if (body['success']) {
        neracaList.value = body['data'];
        loading(false);
      }
    }
  }

  void exportExcel() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      String param =
          thisMonth.value + '_' + thisYear.value + '_' + userId.toString();

      var data = {"param": param};

      var res = await Network().post(data, '/journal/balance-sheet-export');
      var body = jsonDecode(res.body);
      if (body['success']) {
        launchURL(Constant.JOURNAL_REPORT + body['data'].toString());
      }
    }
  }

  void exportPdf() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      String param =
          thisMonth.value + '_' + thisYear.value + '_' + userId.toString();

      var data = {"param": param};

      var res = await Network().post(data, '/journal/balance-sheet-pdf');
      var body = jsonDecode(res.body);
      if (body['success']) {
        launchURL(Constant.JOURNAL_REPORT + body['data'].toString());
      }
    }
  }

  void launchURL(String url) async {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
