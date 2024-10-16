import 'package:flutter/material.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_mont_report.dart';
import 'package:randu_mobile/components/select/select_year_report.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/pengaturan/opening_balance/opening_balance_controller.dart';

class OpeningBalance extends StatefulWidget {
  const OpeningBalance({Key? key}) : super(key: key);

  @override
  State<OpeningBalance> createState() => _OpeningBalanceState();
}

class _OpeningBalanceState extends State<OpeningBalance> {
  final OpeningBalanceController _openingBalance =
      Get.put(OpeningBalanceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: const Text("Generate Opening Balance"),
        ),
        body: Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                Jarak(tinggi: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1 / 2 - 10,
                      child: Obx(() => SelectMonthReport(
                          defValue: _openingBalance.thisMonth.value,
                          label: "Bulan",
                          menuItems: _openingBalance.monthDropdown,
                          code: "opening-balance")),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1 / 2 - 30,
                      child: Obx(() => SelectYearReport(
                          defValue: _openingBalance.thisYear.value,
                          label: "Tahun",
                          menuItems: _openingBalance.yearDropdown,
                          code: "opening-balance")),
                    ),
                  ],
                ),
                Jarak(
                  tinggi: 20,
                ),
                Obx(
                  () => _openingBalance.loading.value
                      ? const SizedBox(
                          child: Center(child: CircularProgressIndicator()))
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.mainColor),
                              onPressed: () {
                                _openingBalance.generateOpeningBalance();
                              },
                              child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: const Text("Submit"))),
                        ),
                )
              ],
            )));
  }
}
