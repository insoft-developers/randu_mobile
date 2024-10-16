import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:randu_mobile/utils/ribuan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JurnalCepatController extends GetxController {
  var jenisTransaksi = "".obs;
  var transactionList = List.empty().obs;
  var transactionLoading = false.obs;
  var selectedDate = "".obs;
  var accountList = List.empty().obs;
  var saveList = List.empty().obs;
  var selectedTransaction = "".obs;
  var loadingTerimaDari = false.obs;
  var receiveFromValue = "".obs;
  var saveToValue = "".obs;
  var nominalRibuan = "0".obs;
  var saveLoading = false.obs;

  void onChangeTransaction(String value) {
    selectedTransaction.value = value;
    getAccountList(value);
  }

  void getTransactionList() async {
    transactionLoading(true);
    var res = await Network().getData("/journal/transaction-type");
    var body = jsonDecode(res.body);
    if (body['success']) {
      transactionList.value = body['data'];
      transactionLoading(false);
    }
  }

  List<DropdownMenuItem<String>> get transaksiDropdown {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems
        .add(const DropdownMenuItem(child: Text("Pilih Transaksi"), value: ""));
    for (var i = 0; i < transactionList.length; i++) {
      if (transactionList[i]['id'] < 3 || transactionList[i]['id'] > 6) {
        menuItems.add(
          DropdownMenuItem(
              child: Text(transactionList[i]['transaction_name'].toString()),
              value: transactionList[i]['id'].toString()),
        );
      }
    }

    return menuItems;
  }

  Future getTransactionDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate!);

    selectedDate.value = formattedDate; //set output date to TextField value.
    return selectedDate;
  }

  void getAccountList(String id) async {
    loadingTerimaDari(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"userid": userId, "id": id};
      var res = await Network().post(data, '/journal/account-receive');
      var body = jsonDecode(res.body);
      if (body['success']) {
        accountList.value = body['data'];
        saveList.value = body['simpan'];
        loadingTerimaDari(false);
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

  List<String> get saveDropdown {
    List<String> items = [];
    for (var i = 0; i < saveList.length; i++) {
      items.add(saveList[i]['name'].toString() +
          ' ( ' +
          saveList[i]['group'].toString() +
          ' )');
    }

    return items;
  }

  void onchangeReceiveFrom(int nilai) {
    String rf = accountList[nilai]['id'].toString() +
        '_' +
        accountList[nilai]['account_code_id'].toString();
    receiveFromValue.value = rf;
  }

  void onchangeSaveTo(int nilai) {
    String st = saveList[nilai]['id'].toString() +
        '_' +
        saveList[nilai]['account_code_id'].toString();
    saveToValue.value = st;
  }

  void setRibuan(int value) {
    nominalRibuan.value = Ribuan.convertToIdr(value, 0);
  }

  void saveQuickJournal(
      String tanggalTransaksi, String keterangan, int nominal) async {
    saveLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "userid": userId,
        "tanggal_transaksi": tanggalTransaksi,
        "jenis_transaksi": selectedTransaction.value,
        "receive_from": receiveFromValue.value,
        "save_to": saveToValue.value,
        "keterangan": keterangan,
        "nominal": nominal
      };

      var res = await Network().post(data, '/journal/save-quick-journal');
      var body = jsonDecode(res.body);
      if (body['success']) {
        saveLoading(false);
        Get.back();
      } else {
        saveLoading(false);
        showError(body['message'].toString());
      }
    }
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
