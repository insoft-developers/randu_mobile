import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_mont_report.dart';
import 'package:randu_mobile/components/select/select_year_report.dart';
import 'package:randu_mobile/components/spasi.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/input_jurnal_shimmer.dart';
import 'package:randu_mobile/laporan/neraca_saldo/neraca_saldo_controller.dart';

class NeracaSaldo extends StatefulWidget {
  const NeracaSaldo({Key? key}) : super(key: key);

  @override
  State<NeracaSaldo> createState() => _NeracaSaldoState();
}

class _NeracaSaldoState extends State<NeracaSaldo> {
  final NeracaSaldoController _laporanController =
      Get.put(NeracaSaldoController());

  @override
  void initState() {
    _laporanController.getNeracaSaldo();
    super.initState();
  }

  _onChangeReport() {
    _laporanController.getNeracaSaldo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: const Text("Neraca Saldo"),
          actions: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _laporanController.exportExcel();
                  },
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
                  onTap: () {
                    _laporanController.exportPdf();
                  },
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
                        defValue: _laporanController.thisMonth.value,
                        label: "Bulan",
                        menuItems: _laporanController.monthDropdown,
                        code: "neraca-saldo")),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 3 + 3,
                    child: Obx(() => SelectYearReport(
                        defValue: _laporanController.thisYear.value,
                        label: "Tahun",
                        menuItems: _laporanController.yearDropdown,
                        code: "neraca-saldo")),
                  ),
                  GestureDetector(
                    onTap: () {
                      _onChangeReport();
                    },
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                    decoration: BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.circular(4)),
                    width: MediaQuery.of(context).size.width * 1 / 3 - 8,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: const Text("Keterangan",
                        style: TextStyle(
                            color: AppColor.putih,
                            fontFamily: FontSetting.reg))),
                Container(
                    decoration: BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.circular(4)),
                    width: MediaQuery.of(context).size.width * 1 / 3 - 10,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: const Text("Debet",
                        style: TextStyle(
                            color: AppColor.putih,
                            fontFamily: FontSetting.reg))),
                Container(
                    decoration: BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.circular(4)),
                    width: MediaQuery.of(context).size.width * 1 / 3 - 10,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: const Text("Kredit",
                        style: TextStyle(
                            color: AppColor.putih,
                            fontFamily: FontSetting.reg))),
              ]),
              Jarak(tinggi: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Obx(
                    () => _laporanController.loading.value
                        ? InputJurnalShimmer(tinggi: 30, jumlah: 12, pad: 0)
                        : _laporanController.neracaSaldo.isEmpty
                            ? const Text("Data tidak ada")
                            : ListView.builder(
                                itemCount:
                                    _laporanController.neracaSaldo.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 2),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  3,
                                              child: Text(
                                                  _laporanController
                                                      .neracaSaldo[index]
                                                          ['name']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          FontSetting.semi,
                                                      color:
                                                          AppColor.mainColor)),
                                            ),
                                            Spasi(lebar: 5),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      1 /
                                                      3 -
                                                  20,
                                              child: Text(
                                                  _laporanController
                                                      .neracaSaldo[index]
                                                          ['debet']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          FontSetting.reg)),
                                            ),
                                            Spasi(lebar: 5),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      1 /
                                                      3 -
                                                  20,
                                              child: Text(
                                                  _laporanController
                                                      .neracaSaldo[index]
                                                          ['credit']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          FontSetting.reg)),
                                            ),
                                          ],
                                        ),
                                        const Divider()
                                      ],
                                    ),
                                  );
                                }),
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                    decoration: BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.circular(4)),
                    width: MediaQuery.of(context).size.width * 1 / 3 - 8,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: const Text("TOTAL",
                        style: TextStyle(
                            color: AppColor.putih,
                            fontFamily: FontSetting.reg))),
                Container(
                    decoration: BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.circular(4)),
                    width: MediaQuery.of(context).size.width * 1 / 3 - 10,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Obx(
                      () => Text(_laporanController.totalDebet.value.toString(),
                          style: const TextStyle(
                              color: AppColor.putih,
                              fontFamily: FontSetting.bold)),
                    )),
                Container(
                    decoration: BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.circular(4)),
                    width: MediaQuery.of(context).size.width * 1 / 3 - 10,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Obx(
                      () => Text(
                          _laporanController.totalCredit.value.toString(),
                          style: const TextStyle(
                              color: AppColor.putih,
                              fontFamily: FontSetting.bold)),
                    )),
              ]),
            ],
          )),
    );
  }
}
