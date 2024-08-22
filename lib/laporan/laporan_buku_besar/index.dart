import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_mont_report.dart';
import 'package:randu_mobile/components/select/select_year_report.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/input_jurnal_shimmer.dart';
import 'package:randu_mobile/homepage/shimmer/text_shimmer.dart';
import 'package:randu_mobile/laporan/laporan_buku_besar/buku_besar_controller.dart';

class BukuBesar extends StatefulWidget {
  const BukuBesar({Key? key}) : super(key: key);

  @override
  State<BukuBesar> createState() => _BukuBesarState();
}

class _BukuBesarState extends State<BukuBesar> {
  final BukuBesarController _laporanController = Get.put(BukuBesarController());

  _onChangeReport() {
    _laporanController.getBukuBesar();
  }

  @override
  void initState() {
    _laporanController.getAccountList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: const Text("Laporan Buku Besar"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Jarak(tinggi: 10),
          Obx(
            () => _laporanController.loading.value
                ? TextShimmer(
                    lebar: MediaQuery.of(context).size.width, tinggi: 60)
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Obx(
                      () => DropdownSearch<String>(
                        showSearchBox: true,
                        mode: Mode.MENU,
                        showSelectedItems: true,
                        items: _laporanController.accountDropdown,
                        dropdownSearchDecoration: const InputDecoration(
                            border: InputBorder.none,
                            label: Text("Pilih akun")),
                        onChanged: (value) {
                          _laporanController.onChangeAccount(value.toString());
                        },
                        selectedItem: _laporanController.selectedAccount.value,
                      ),
                    ),
                  ),
          ),
          Jarak(tinggi: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 1 / 3 + 3,
                child: Obx(() => SelectMonthReport(
                    defValue: _laporanController.thisMonth.value,
                    label: "Bulan",
                    menuItems: _laporanController.monthDropdown,
                    code: "buku-besar")),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 1 / 3 + 3,
                child: Obx(() => SelectYearReport(
                    defValue: _laporanController.thisYear.value,
                    label: "Tahun",
                    menuItems: _laporanController.yearDropdown,
                    code: "buku-besar")),
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
            Container(
                decoration: BoxDecoration(
                    color: AppColor.mainColor,
                    borderRadius: BorderRadius.circular(4)),
                width: MediaQuery.of(context).size.width * 1 / 3 - 8,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: const Text("Saldo",
                    style: TextStyle(
                        color: AppColor.putih, fontFamily: FontSetting.reg))),
          ]),
          Jarak(
            tinggi: 10,
          ),
          Obx(
            () => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: _laporanController.loadLedger.value
                    ? InputJurnalShimmer(tinggi: 30, jumlah: 10, pad: 0)
                    : _laporanController.bukuBesar.isEmpty
                        ? const Text("Data tidak ada")
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _laporanController.bukuBesar.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  2 /
                                                  3 -
                                              23,
                                          child: Text(
                                              _laporanController
                                                  .bukuBesar[index]
                                                      ['transaction_name']
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontFamily: FontSetting.reg)),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  3 -
                                              17,
                                          child: Text(
                                              _laporanController
                                                  .bukuBesar[index]
                                                      ['transaction_date']
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontFamily: FontSetting.reg)),
                                        ),
                                      ],
                                    ),
                                    Jarak(tinggi: 2),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1 /
                                              3,
                                          child: Text(
                                              _laporanController
                                                  .bukuBesar[index]['debet']
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontFamily:
                                                      FontSetting.bold)),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  3 -
                                              20,
                                          child: Text(
                                              _laporanController
                                                  .bukuBesar[index]['credit']
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontFamily:
                                                      FontSetting.bold)),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  3 -
                                              20,
                                          child: Text(
                                              _laporanController
                                                  .bukuBesar[index]['saldo']
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontFamily:
                                                      FontSetting.bold)),
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
          Jarak(
            tinggi: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
                decoration: BoxDecoration(
                    color: AppColor.mainColor,
                    borderRadius: BorderRadius.circular(4)),
                width: MediaQuery.of(context).size.width * 1 / 3 - 10,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Obx(
                  () => Text(_laporanController.totalDebet.value,
                      style: const TextStyle(
                          color: AppColor.putih, fontFamily: FontSetting.bold)),
                )),
            Container(
                decoration: BoxDecoration(
                    color: AppColor.mainColor,
                    borderRadius: BorderRadius.circular(4)),
                width: MediaQuery.of(context).size.width * 1 / 3 - 10,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Obx(
                  () => Text(_laporanController.totalCredit.value,
                      style: const TextStyle(
                          color: AppColor.putih, fontFamily: FontSetting.bold)),
                )),
            Container(
                decoration: BoxDecoration(
                    color: AppColor.mainColor,
                    borderRadius: BorderRadius.circular(4)),
                width: MediaQuery.of(context).size.width * 1 / 3 - 8,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Obx(
                  () => Text(_laporanController.totalSaldo.value,
                      style: const TextStyle(
                          color: AppColor.putih, fontFamily: FontSetting.bold)),
                )),
          ]),
        ]),
      ),
    );
  }
}
