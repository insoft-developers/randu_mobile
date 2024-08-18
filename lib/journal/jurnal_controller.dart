import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:sweetalertv2/sweetalertv2.dart';

class JurnalController extends GetxController {
  var now = DateTime.now();
  var formatter = DateFormat('MM');
  var formatterYear = DateFormat('yyyy');

  var loading = false.obs;
  var journalList = List.empty().obs;
  var thisMonth = "".obs;
  var thisYear = "".obs;
  var tahunSekarang = "".obs;
  var deleteLoading = false.obs;
  var previewLoading = false.obs;
  var previewJournal = <String, dynamic>{}.obs;
  var previewList = List.empty().obs;
  var previewDate = "".obs;
  var totalDebit = 0.obs;
  var totalKredit = 0.obs;

  @override
  void onInit() {
    String formattedDate = formatter.format(now);
    thisMonth.value = formattedDate.toString();
    String formattedYear = formatterYear.format(now);
    thisYear.value = formattedYear.toString();
    tahunSekarang.value = formattedYear.toString();
    super.onInit();
  }

  void getJournalList() async {
    loading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "userid": userId,
        "bulan": thisMonth.value.toString(),
        "tahun": thisYear.value.toString(),
        "cari": ""
      };
      var res = await Network().post(data, '/journal/list');
      var body = jsonDecode(res.body);
      if (body['success']) {
        loading(false);
        journalList.value = body['data'];
      }
    }
  }

  void searchJournalList(String cari) async {
    loading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "userid": userId,
        "bulan": thisMonth.value.toString(),
        "tahun": thisYear.value.toString(),
        "cari": cari
      };
      var res = await Network().post(data, '/journal/list');
      var body = jsonDecode(res.body);
      if (body['success']) {
        loading(false);
        journalList.value = body['data'];
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

  void onMonthChange(String value) {
    thisMonth.value = value;
    getJournalList();
  }

  void onYearChange(String value) {
    thisYear.value = value;
    getJournalList();
  }

  void onJournalDelete(int id) async {
    deleteLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"userid": userId, "id": id};
      var res = await Network().post(data, '/journal/delete-journal');
      var body = jsonDecode(res.body);
      if (body['success']) {
        deleteLoading(false);
        getJournalList();
      } else {
        SweetAlertV2.show(Get.context,
            title: "Gagal",
            subtitle: body['message'].toString(),
            style: SweetAlertV2Style.error);
      }
    }
  }

  void journalPreview(String id) async {
    previewLoading(true);
    var data = {"journal_id": id};
    var res = await Network().post(data, '/journal/journal-preview');
    var body = jsonDecode(res.body);
    if (body['success']) {
      previewLoading(false);
      previewJournal.value = body['data']['jurnal'];
      previewList.value = body['data']['list'];
      previewDate.value = body['data']['tanggal'];
      totalDebit.value = body['data']['total_debit'];
      totalKredit.value = body['data']['total_kredit'];
    }
  }
}
