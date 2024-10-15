import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:randu_mobile/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LaporanJurnalController extends GetxController {
  var now = DateTime.now();
  var formatter = DateFormat('MM');
  var formatterYear = DateFormat('yyyy');
  var thisMonth = "".obs;
  var thisYear = "".obs;
  var tahunSekarang = "".obs;

  var loading = false.obs;
  var laporanContent = List.empty().obs;
  var totalDebet = 0.obs;
  var totalCredit = 0.obs;

  @override
  void onInit() {
    String formattedDate = formatter.format(now);
    thisMonth.value = formattedDate.toString();
    String formattedYear = formatterYear.format(now);
    thisYear.value = formattedYear.toString();
    tahunSekarang.value = formattedYear.toString();
    super.onInit();
  }

  void exportExcel() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      String param =
          thisMonth.value + '_' + thisYear.value + '_' + userId.toString();

      var data = {"param": param};

      var res = await Network().post(data, '/journal/journal-report-export');
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

      var res = await Network().post(data, '/journal/journal-report-pdf');
      var body = jsonDecode(res.body);
      if (body['success']) {
        launchURL(Constant.JOURNAL_REPORT + body['data'].toString());
      }
    }
  }

  void launchURL(String url) async {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void getDataLaporan(String month, String year) async {
    loading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "month_from": month.isEmpty ? thisMonth.value : month,
        "year_from": year.isEmpty ? thisYear.value : year,
        "userid": userId
      };

      var res = await Network().post(data, '/journal/journal-report');
      var body = jsonDecode(res.body);
      if (body['success']) {
        loading(false);
        laporanContent.value = body['data'];
        totalDebet.value = body['debet'];
        totalCredit.value = body['credit'];
        print(body);
      }
    }
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
}
