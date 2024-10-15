import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_mont_report.dart';
import 'package:randu_mobile/components/select/select_year_report.dart';
import 'package:randu_mobile/components/spasi.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/input_jurnal_shimmer.dart';
import 'package:randu_mobile/laporan/laporan_jurnal/laporan_jurnal_controller.dart';
import 'package:randu_mobile/utils/ribuan.dart';

class LaporanJurnal extends StatefulWidget {
  const LaporanJurnal({Key? key}) : super(key: key);

  @override
  State<LaporanJurnal> createState() => _LaporanJurnalState();
}

class _LaporanJurnalState extends State<LaporanJurnal> {
  final LaporanJurnalController _laporanController =
      Get.put(LaporanJurnalController());

  @override
  void initState() {
    _laporanController.getDataLaporan("", "");
    super.initState();
  }

  _onChangeReport() {
    _laporanController.getDataLaporan(
        _laporanController.thisMonth.value, _laporanController.thisYear.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColor.mainColor,
            title: const Text("Laporan Jurnal"),
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
          child: Column(children: [
            Jarak(tinggi: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1 / 3 + 3,
                  child: Obx(() => SelectMonthReport(
                      defValue: _laporanController.thisMonth.value,
                      label: "Bulan",
                      menuItems: _laporanController.monthDropdown,
                      code: "laporan-jurnal")),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1 / 3 + 3,
                  child: Obx(() => SelectYearReport(
                      defValue: _laporanController.thisYear.value,
                      label: "Tahun",
                      menuItems: _laporanController.yearDropdown,
                      code: "laporan-jurnal")),
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
                          color: AppColor.putih, fontFamily: FontSetting.reg))),
              Container(
                  decoration: BoxDecoration(
                      color: AppColor.mainColor,
                      borderRadius: BorderRadius.circular(4)),
                  width: MediaQuery.of(context).size.width * 1 / 3 - 10,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: const Text("Debet",
                      style: TextStyle(
                          color: AppColor.putih, fontFamily: FontSetting.reg))),
              Container(
                  decoration: BoxDecoration(
                      color: AppColor.mainColor,
                      borderRadius: BorderRadius.circular(4)),
                  width: MediaQuery.of(context).size.width * 1 / 3 - 10,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: const Text("Kredit",
                      style: TextStyle(
                          color: AppColor.putih, fontFamily: FontSetting.reg))),
            ]),
            Jarak(tinggi: 10),
            Obx(
              () => _laporanController.loading.value
                  ? Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: InputJurnalShimmer(
                              tinggi: 30, jumlah: 20, pad: 0)))
                  : Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: _laporanController.laporanContent.length,
                            itemBuilder: (BuildContext context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    2 /
                                                    3 -
                                                10,
                                        child: Text(
                                            _laporanController
                                                .laporanContent[index]
                                                    ['transaction_name']
                                                .toString(),
                                            style: const TextStyle(
                                                fontFamily: FontSetting.bold,
                                                color: AppColor.mainColor,
                                                fontSize: 16)),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    1 /
                                                    3 -
                                                30,
                                        child: Text(
                                            _laporanController
                                                .laporanContent[index]
                                                    ['transaction_date']
                                                .toString(),
                                            style: const TextStyle(
                                                fontFamily: FontSetting.bold,
                                                color: AppColor.mainColor,
                                                fontSize: 13)),
                                      ),
                                    ],
                                  ),
                                  Jarak(tinggi: 5),
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemCount: _laporanController
                                              .laporanContent[index]['list']
                                              .length,
                                          itemBuilder:
                                              (BuildContext context2, index2) {
                                            return SizedBox(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 120,
                                                      child: Text(_laporanController
                                                          .laporanContent[index]
                                                              ['list'][index2][
                                                              'asset_data_name']
                                                          .toString()),
                                                    ),
                                                    Spasi(lebar: 5),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width *
                                                                  1 /
                                                                  3 -
                                                              10,
                                                      child: Text(
                                                          Ribuan.formatAngka(
                                                              _laporanController
                                                                  .laporanContent[
                                                                      index]
                                                                      ['list']
                                                                      [index2]
                                                                      ['debet']
                                                                  .toString())),
                                                    ),
                                                    Text(Ribuan.formatAngka(
                                                        _laporanController
                                                            .laporanContent[
                                                                index]['list']
                                                                [index2]
                                                                ['credit']
                                                            .toString()))
                                                  ],
                                                ),
                                                const Divider()
                                              ],
                                            ));
                                          })),
                                ],
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
                  child: const Text("Total",
                      style: TextStyle(
                          color: AppColor.putih, fontFamily: FontSetting.reg))),
              Container(
                  decoration: BoxDecoration(
                      color: AppColor.mainColor,
                      borderRadius: BorderRadius.circular(4)),
                  width: MediaQuery.of(context).size.width * 1 / 3 - 10,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Obx(
                    () => Text(
                        Ribuan.formatAngka(
                            _laporanController.totalDebet.value.toString()),
                        style: const TextStyle(
                            color: AppColor.putih,
                            fontFamily: FontSetting.reg)),
                  )),
              Container(
                  decoration: BoxDecoration(
                      color: AppColor.mainColor,
                      borderRadius: BorderRadius.circular(4)),
                  width: MediaQuery.of(context).size.width * 1 / 3 - 10,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Obx(() => Text(
                      Ribuan.formatAngka(
                          _laporanController.totalCredit.value.toString()),
                      style: const TextStyle(
                          color: AppColor.putih,
                          fontFamily: FontSetting.reg)))),
            ]),
          ]),
        ));
  }
}
