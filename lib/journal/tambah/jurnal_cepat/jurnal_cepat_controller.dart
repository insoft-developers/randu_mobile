import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:randu_mobile/api/network.dart';

class JurnalCepatController extends GetxController {
  var jenisTransaksi = "".obs;
  var transactionList = List.empty().obs;
  var transactionLoading = false.obs;
  var selectedDate = "".obs;

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

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      selectedDate.value = formattedDate; //set output date to TextField value.
      return selectedDate;
    }
  }
}
