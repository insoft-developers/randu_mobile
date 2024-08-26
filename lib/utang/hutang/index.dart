import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/components/input_search.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_mont_report.dart';
import 'package:randu_mobile/components/select/select_year_report.dart';
import 'package:randu_mobile/components/spasi.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/input_jurnal_shimmer.dart';
import 'package:randu_mobile/utang/hutang/hutang_controller.dart';
import 'package:randu_mobile/utils/ribuan.dart';
import 'package:randu_mobile/utils/tanggal.dart';

class Hutang extends StatefulWidget {
  const Hutang({Key? key}) : super(key: key);

  @override
  State<Hutang> createState() => _HutangState();
}

class _HutangState extends State<Hutang> {
  final HutangController _hutangController = Get.put(HutangController());
  final TextEditingController _textCari = TextEditingController();

  @override
  void initState() {
    _hutangController.getHutangData("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: const Text("Daftar Hutang"),
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Obx(() => SelectMonthReport(
                    defValue: _hutangController.selectedCategory.value,
                    label: "Kategori",
                    menuItems: _hutangController.categoryDropdown,
                    code: "debt-category")),
              ),
              Jarak(tinggi: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 2,
                    child: Obx(() => SelectMonthReport(
                        defValue: _hutangController.thisMonth.value,
                        label: "Bulan",
                        menuItems: _hutangController.monthDropdown,
                        code: "debt-list")),
                  ),
                  Spasi(lebar: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 2 - 30,
                    child: Obx(() => SelectYearReport(
                        defValue: _hutangController.thisYear.value,
                        label: "Tahun",
                        menuItems: _hutangController.yearDropdown,
                        code: "debt-list")),
                  ),
                ],
              ),
              Jarak(tinggi: 5),
              InputSearch(
                  hint: "Cari Transaksi",
                  textInputType: TextInputType.text,
                  iconData: Icons.search,
                  textEditingController: _textCari,
                  obsecureText: false),
              const Divider(),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Obx(
                    () => _hutangController.loading.value
                        ? InputJurnalShimmer(tinggi: 160, jumlah: 10, pad: 0)
                        : ListView.builder(
                            itemCount: _hutangController.hutangList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border:
                                        Border.all(color: AppColor.displayLine),
                                    color: AppColor.display),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              42,
                                          child: Text(
                                              _hutangController
                                                  .hutangList[index]['name']
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontFamily: FontSetting.bold,
                                                  color: AppColor.mainColor,
                                                  fontSize: 16)),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1 /
                                              3,
                                          child: Text(
                                              Tanggal.getOnlyDate(
                                                  _hutangController
                                                      .hutangList[index]
                                                          ['created_at']
                                                      .toString()),
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  fontFamily: FontSetting.reg)),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                          _hutangController.hutangList[index]
                                                  ['type']
                                              .toString(),
                                          style: const TextStyle(
                                              fontFamily: FontSetting.reg)),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                          _hutangController.hutangList[index]
                                                  ['sub_type']
                                              .toString(),
                                          style: const TextStyle(
                                              fontFamily: FontSetting.reg)),
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    5 -
                                                20,
                                            child: _hutangController
                                                            .hutangList[index]
                                                        ['sync_status'] ==
                                                    1
                                                ? Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: AppColor.putih),
                                                    child: const Icon(
                                                      Icons.sync,
                                                      color: AppColor.hijau,
                                                    ),
                                                  )
                                                : Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: AppColor.putih),
                                                    child: const Icon(
                                                      Icons.sync_disabled,
                                                      color: AppColor.merah,
                                                    ),
                                                  )),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  4 /
                                                  5 -
                                              42,
                                          child: Text(
                                              "Rp. " +
                                                  Ribuan.formatAngka(
                                                      _hutangController
                                                          .hutangList[index]
                                                              ['amount']
                                                          .toString()),
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  fontFamily: FontSetting.bold,
                                                  color: AppColor.hijau,
                                                  fontSize: 20)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
