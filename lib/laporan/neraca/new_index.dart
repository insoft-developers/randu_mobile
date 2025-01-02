import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_mont_report.dart';
import 'package:randu_mobile/components/select/select_year_report.dart';
import 'package:randu_mobile/components/spasi.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/input_jurnal_shimmer.dart';
import 'package:randu_mobile/laporan/neraca/neraca_controller.dart';
import 'package:randu_mobile/laporan/neraca/neraca_webview.dart';
import 'package:randu_mobile/laporan/neraca/new_neraca_controller.dart';
import 'package:randu_mobile/premium.dart';
import 'package:randu_mobile/premium_controller.dart';
import 'package:randu_mobile/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewNeraca extends StatefulWidget {
  const NewNeraca({Key? key}) : super(key: key);

  @override
  State<NewNeraca> createState() => _NewNeracaState();
}

class _NewNeracaState extends State<NewNeraca> {
  final NewNeracaController _laporan = Get.put(NewNeracaController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: const Text("Laporan Neraca"),
          actions: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Image.asset('images/excel_icon.png'),
                    width: 25,
                    height: 25,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Image.asset('images/pdf_icon.png'),
                    width: 25,
                    height: 25,
                  ),
                ),
              ],
            )
          ]),
      body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 3 + 3,
                    child: Obx(() => SelectMonthReport(
                        defValue: _laporan.thisMonth.value,
                        label: "Bulan",
                        menuItems: _laporan.monthDropdown,
                        code: "balance-sheet")),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 3 + 3,
                    child: Obx(() => SelectYearReport(
                        defValue: _laporan.thisYear.value,
                        label: "Tahun",
                        menuItems: _laporan.yearDropdown,
                        code: "balance-sheet")),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                            color: AppColor.mainColor,
                            borderRadius: BorderRadius.circular(4)),
                        child: const Text("Submit",
                            style: TextStyle(color: AppColor.putih))),
                  ),
                ],
              ),
              Jarak(
                tinggi: 10,
              ),
              NeracaWebview(
                  paymentUrl:
                      Constant.BASE_URL + 'neraca-webview/5109/10/2024/10/2024')
            ],
          )),
    );
  }
}
