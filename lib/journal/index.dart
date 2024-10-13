import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_month.dart';
import 'package:randu_mobile/components/select/select_year.dart';
import 'package:randu_mobile/components/spasi.dart';
import 'package:randu_mobile/components/textcari.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/list_shimmer.dart';
import 'package:randu_mobile/journal/edit/index.dart';
import 'package:randu_mobile/journal/jurnal_controller.dart';
import 'package:randu_mobile/journal/lihat.dart';
import 'package:randu_mobile/utils/warna.dart';
// import 'package:sweetalertv2/sweetalertv2.dart';

class Journal extends StatefulWidget {
  const Journal({Key? key}) : super(key: key);

  @override
  State<Journal> createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  final JurnalController _jurnalController = Get.put(JurnalController());
  final TextEditingController _cariText = TextEditingController();

  @override
  void initState() {
    _jurnalController.getJournalList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Jarak(tinggi: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 150,
                child: Obx(() => SelectMonth(
                    defValue: _jurnalController.thisMonth.value,
                    label: "Bulan",
                    menuItems: _jurnalController.monthDropdown)),
              ),
              SizedBox(
                width: 150,
                child: Obx(() => SelectYear(
                    defValue: _jurnalController.thisYear.value,
                    label: "Tahun",
                    menuItems: _jurnalController.yearDropdown)),
              ),
            ],
          ),
          Jarak(tinggi: 10),
          TextCari(
              hint: "Cari Transaksi Jurnal",
              textInputType: TextInputType.text,
              iconData: Icons.search,
              textEditingController: _cariText,
              obsecureText: false),
          const Divider(),
          Obx(
            () => _jurnalController.loading.value
                ? const Expanded(child: ListShimmer())
                : _jurnalController.journalList.isEmpty
                    ? const Expanded(
                        child: Center(
                            child: SizedBox(child: Text("Tidak ada data"))),
                      )
                    : Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: _jurnalController.journalList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: AppColor.displayLine,
                                          width: 0.5),
                                      color: AppColor.display),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 70,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: HexColor(_jurnalController
                                              .journalList[index]['color_date']
                                              .toString()),
                                        ),
                                        child: Text(
                                            _jurnalController.journalList[index]
                                                    ['tanggal']
                                                .toString(),
                                            style: const TextStyle(
                                                fontFamily: FontSetting.bold,
                                                fontSize: 20,
                                                color: Colors.white)),
                                      ),
                                      Spasi(lebar: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  120,
                                              child: Text(
                                                  _jurnalController.journalList[index]
                                                                  ['edit_count']
                                                              .toString()
                                                              .isNotEmpty &&
                                                          _jurnalController.journalList[index]['edit_count'].toString() !=
                                                              "0"
                                                      ? _jurnalController.journalList[index]['transaction_name'].toString() +
                                                          ' ( ' +
                                                          _jurnalController
                                                              .journalList[index]
                                                                  ['edit_count']
                                                              .toString() +
                                                          ' )'
                                                      : _jurnalController.journalList[index]['transaction_name']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontFamily: _jurnalController.journalList[index]['not_balance'] == 1
                                                          ? FontSetting.bold
                                                          : FontSetting.reg,
                                                      fontSize: 15,
                                                      color: _jurnalController.journalList[index]['not_balance'] == 1 ? Colors.red : AppColor.mainColor)),
                                            ),
                                            Jarak(tinggi: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  child: Text(
                                                      _jurnalController
                                                          .journalList[index]
                                                              ['angka']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          fontFamily:
                                                              FontSetting
                                                                  .bold)),
                                                ),
                                                SizedBox(
                                                  child: Text(
                                                      _jurnalController
                                                          .journalList[index]
                                                              ['created']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              FontSetting.reg)),
                                                ),
                                              ],
                                            ),
                                            Jarak(tinggi: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                _jurnalController.journalList[
                                                            index]['awal'] ==
                                                        1
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          Get.to(() => JournalPreview(
                                                              journalId: _jurnalController
                                                                  .journalList[
                                                                      index]
                                                                      ['id']
                                                                  .toString()));
                                                        },
                                                        child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: Colors
                                                                    .green),
                                                            child: const Icon(
                                                                Icons.preview,
                                                                size: 17,
                                                                color: Colors
                                                                    .white)),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () {
                                                          Get.to(JournalEdit(
                                                                  id: _jurnalController
                                                                              .journalList[
                                                                          index]
                                                                      ['id']))!
                                                              .then((value) =>
                                                                  _jurnalController
                                                                      .getJournalList());
                                                        },
                                                        child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: Colors
                                                                    .orange),
                                                            child: const Icon(
                                                                Icons.edit,
                                                                size: 17,
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                Spasi(lebar: 20),
                                                GestureDetector(
                                                  onTap: () {
                                                    // SweetAlertV2.show(context,
                                                    //     title: "Hapus Data ?",
                                                    //     subtitle: "",
                                                    //     style: SweetAlertV2Style
                                                    //         .confirm,
                                                    //     showCancelButton: true,
                                                    //     onPress:
                                                    //         (bool isConfirm) {
                                                    //   if (isConfirm) {
                                                    //     Get.back();
                                                    //     _jurnalController
                                                    //         .onJournalDelete(
                                                    //             _jurnalController
                                                    //                     .journalList[
                                                    //                 index]['id']);
                                                    //   } else {
                                                    //     Get.back();
                                                    //   }
                                                    //   return false;
                                                    // });
                                                  },
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color:
                                                              Colors.red[900]),
                                                      child: const Icon(
                                                          Icons.delete,
                                                          size: 17,
                                                          color: Colors.white)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
