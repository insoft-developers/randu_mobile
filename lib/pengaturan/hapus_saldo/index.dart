import 'package:flutter/material.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_mont_report.dart';
import 'package:randu_mobile/components/select/select_year_report.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/pengaturan/hapus_saldo/hapus_saldo_controller.dart';

class HapusSaldo extends StatefulWidget {
  const HapusSaldo({Key? key}) : super(key: key);

  @override
  State<HapusSaldo> createState() => _HapusSaldoState();
}

class _HapusSaldoState extends State<HapusSaldo> {
  final HapusSaldoController _hapusSaldo = Get.put(HapusSaldoController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: const Text("Hapus Saldo Awal"),
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
                          defValue: _hapusSaldo.thisMonth.value,
                          label: "Bulan",
                          menuItems: _hapusSaldo.monthDropdown,
                          code: "hapus-saldo")),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1 / 2 - 30,
                      child: Obx(() => SelectYearReport(
                          defValue: _hapusSaldo.thisYear.value,
                          label: "Tahun",
                          menuItems: _hapusSaldo.yearDropdown,
                          code: "hapus-saldo")),
                    ),
                  ],
                ),
                Jarak(
                  tinggi: 20,
                ),
                Obx(
                  () => _hapusSaldo.loading.value
                      ? const SizedBox(
                          child: Center(child: CircularProgressIndicator()))
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.mainColor),
                              onPressed: () {
                                _hapusSaldo.initialDelete();
                              },
                              child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: const Text("Submit",
                                      style: TextStyle(color: Colors.white)))),
                        ),
                )
              ],
            )));
  }
}
