import 'dart:convert';

import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BukuBesarController extends GetxController {
  var now = DateTime.now();
  var formatter = DateFormat('MM');
  var formatterYear = DateFormat('yyyy');
  var loading = false.obs;
  var thisMonth = "".obs;
  var thisYear = "".obs;
  var tahunSekarang = "".obs;
  var accountList = List.empty().obs;
  var selectedAccount = "".obs;
  var selectedAccountValue = "".obs;
  var loadLedger = false.obs;
  var bukuBesar = List.empty().obs;
  var totalDebet = "0".obs;
  var totalCredit = "0".obs;
  var totalSaldo = "0".obs;

  @override
  void onInit() {
    String formattedDate = formatter.format(now);
    thisMonth.value = formattedDate.toString();
    String formattedYear = formatterYear.format(now);
    thisYear.value = formattedYear.toString();
    tahunSekarang.value = formattedYear.toString();
    super.onInit();
  }

  onChangeAccount(String value) {
    selectedAccount.value = value;

    int indexSelected = accountDropdown.indexOf(value);
    Map<String, dynamic> _selectedAccount = accountList[indexSelected];
    String _accountId =
        "${_selectedAccount['id']}_${_selectedAccount['account_code_id']}";
    selectedAccountValue.value = _accountId;
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

  void getAccountList() async {
    loading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"userid": userId};
      var res = await Network().post(data, '/journal/account-by-user');
      var body = jsonDecode(res.body);
      if (body['success']) {
        loading(false);
        accountList.value = body['data'];
      }
    }
  }

  List<String> get accountDropdown {
    List<String> items = [];

    for (var i = 0; i < accountList.length; i++) {
      items.add(accountList[i]['name'].toString() +
          ' ( ' +
          accountList[i]['group'].toString() +
          ' )');
    }

    return items;
  }

  void getBukuBesar() async {
    loadLedger(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "estimation": selectedAccountValue.value,
        "month_from": thisMonth.value,
        "year_from": thisYear.value,
        "userid": userId
      };
      var res = await Network().post(data, '/journal/general-ledger');
      var body = jsonDecode(res.body);
      if (body['success']) {
        loadLedger(false);
        bukuBesar.value = body['data'];
        totalDebet.value = body['total_debet'];
        totalCredit.value = body['total_credit'];
        totalSaldo.value = body['total_saldo'];
      } else {
        showError(body['message'].toString());
        loadLedger(false);
      }
    }
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
}
