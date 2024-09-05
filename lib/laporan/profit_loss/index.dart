import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_mont_report.dart';
import 'package:randu_mobile/components/select/select_year_report.dart';
import 'package:randu_mobile/components/spasi.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/input_jurnal_shimmer.dart';
import 'package:randu_mobile/laporan/profit_loss/profit_loss_controller.dart';

class ProfitLoss extends StatefulWidget {
  const ProfitLoss({Key? key}) : super(key: key);

  @override
  State<ProfitLoss> createState() => _ProfitLossState();
}

class _ProfitLossState extends State<ProfitLoss> {
  final ProfitLossController _laporanController =
      Get.put(ProfitLossController());

  @override
  void initState() {
    _laporanController.getProfitLoss();
    super.initState();
  }

  _onChangeReport() {
    _laporanController.getProfitLoss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: const Text("Laporan Laba Rugi"),
      ),
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
                        code: "profit-loss")),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 3 + 3,
                    child: Obx(() => SelectYearReport(
                        defValue: _laporanController.thisYear.value,
                        label: "Tahun",
                        menuItems: _laporanController.yearDropdown,
                        code: "profit-loss")),
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
                    child: const Text("*",
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
                    child: const Text("*",
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
                        : _laporanController.profitLoss.isEmpty
                            ? const Text("Data tidak ada")
                            : ListView.builder(
                                itemCount: _laporanController.profitLoss.length,
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
                                                      .profitLoss[index]
                                                          ['header']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          FontSetting.semi,
                                                      color:
                                                          AppColor.mainColor)),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: ListView.builder(
                                              physics: const ScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: _laporanController
                                                  .profitLoss[index]['content']
                                                  .length,
                                              itemBuilder: (context, index2) {
                                                return Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  1 /
                                                                  3 -
                                                              20,
                                                          child: Text(
                                                              _laporanController
                                                                  .profitLoss[
                                                                      index][
                                                                      'content']
                                                                      [index2]
                                                                      ['name']
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      FontSetting
                                                                          .reg)),
                                                        ),
                                                        Spasi(lebar: 10),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  1 /
                                                                  3 -
                                                              20,
                                                          child: Text(
                                                              _laporanController
                                                                  .profitLoss[
                                                                      index][
                                                                      'content']
                                                                      [index2]
                                                                      ['amount']
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      FontSetting
                                                                          .reg)),
                                                        ),
                                                      ],
                                                    ),
                                                    const Divider()
                                                  ],
                                                );
                                              }),
                                        ),
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
                                                  2,
                                              child: Text(
                                                  _laporanController
                                                      .profitLoss[index]
                                                          ['footer']
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
                                                      2 -
                                                  40,
                                              child: Text(
                                                  _laporanController
                                                      .profitLoss[index]
                                                          ['footer_value']
                                                      .toString(),
                                                  textAlign: TextAlign.end,
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          FontSetting.bold)),
                                            ),
                                            Spasi(lebar: 5),
                                          ],
                                        ),
                                        Jarak(tinggi: 5),
                                        _laporanController.profitLoss[index]
                                                    ['final']
                                                .toString()
                                                .isEmpty
                                            ? const SizedBox()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1 /
                                                            2,
                                                    child: Text(
                                                        _laporanController
                                                            .profitLoss[index]
                                                                ['final']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                FontSetting
                                                                    .bold,
                                                            color: AppColor
                                                                .hijau)),
                                                  ),
                                                  Spasi(lebar: 5),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                1 /
                                                                2 -
                                                            40,
                                                    child: Text(
                                                        _laporanController
                                                            .profitLoss[index]
                                                                ['final_value']
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                FontSetting
                                                                    .bold,
                                                            color: AppColor
                                                                .hijau)),
                                                  ),
                                                  Spasi(lebar: 5),
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
            ],
          )),
    );
  }
}
