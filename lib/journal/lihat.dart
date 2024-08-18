import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/color/app_color.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/spasi.dart';
import 'package:randu_mobile/homepage/shimmer/input_jurnal_shimmer.dart';
import 'package:randu_mobile/homepage/shimmer/text_shimmer.dart';
import 'package:randu_mobile/journal/jurnal_controller.dart';
import 'package:randu_mobile/utils/ribuan.dart';

// ignore: must_be_immutable
class JournalPreview extends StatefulWidget {
  String journalId;
  JournalPreview({Key? key, required this.journalId}) : super(key: key);

  @override
  State<JournalPreview> createState() => _JournalPreviewState();
}

class _JournalPreviewState extends State<JournalPreview> {
  final JurnalController _jurnalController = Get.put(JurnalController());

  @override
  void initState() {
    _jurnalController.journalPreview(widget.journalId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: const Text("Lihat Saldo Awal"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: _jurnalController.previewLoading.value
                  ? TextShimmer(
                      lebar: MediaQuery.of(context).size.width, tinggi: 30)
                  : Text(
                      _jurnalController.previewDate.value +
                          ' - ' +
                          _jurnalController.previewJournal['transaction_name']
                              .toString(),
                      style:
                          const TextStyle(fontFamily: 'Rubik', fontSize: 18)))),
          Jarak(tinggi: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => _jurnalController.previewLoading.value
                        ? TextShimmer(lebar: 150, tinggi: 30)
                        : Text(
                            "(D) ${Ribuan.formatAngka(_jurnalController.totalDebit.value.toString())}",
                            style: const TextStyle(
                                fontFamily: 'RubikBold',
                                color: AppColor.mainColor)),
                  ),
                  Obx(
                    () => _jurnalController.previewLoading.value
                        ? TextShimmer(lebar: 150, tinggi: 30)
                        : Text(
                            "(K) ${Ribuan.formatAngka(_jurnalController.totalKredit.value.toString())}",
                            style: const TextStyle(
                                fontFamily: 'RubikBold',
                                color: AppColor.mainColor)),
                  ),
                ]),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Obx(
                () => _jurnalController.previewLoading.value
                    ? InputJurnalShimmer(tinggi: 60, jumlah: 6, pad: 0)
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _jurnalController.previewList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColor.mainColor),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                          1 /
                                          3 -
                                      32,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Estimasi",
                                          style: TextStyle(
                                              fontFamily: 'RubikBold')),
                                      const Divider(),
                                      Text(
                                          _jurnalController.previewList[index]
                                                  ['asset_data_name']
                                              .toString(),
                                          style: const TextStyle(
                                              fontFamily: 'Rubik',
                                              fontSize: 16)),
                                    ],
                                  ),
                                ),
                                Spasi(lebar: 5),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                          1 /
                                          3 -
                                      10,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Debet (D)",
                                          style: TextStyle(
                                              fontFamily: 'RubikBold')),
                                      const Divider(),
                                      Text(
                                          Ribuan.formatAngka(_jurnalController
                                              .previewList[index]['debet']
                                              .toString()),
                                          style: const TextStyle(
                                              fontFamily: 'Rubik',
                                              fontSize: 16)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                          1 /
                                          3 -
                                      5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Kredit (K)",
                                          style: TextStyle(
                                              fontFamily: 'RubikBold')),
                                      const Divider(),
                                      Text(
                                          Ribuan.formatAngka(_jurnalController
                                              .previewList[index]['credit']
                                              .toString()),
                                          style: const TextStyle(
                                              fontFamily: 'Rubik',
                                              fontSize: 16)),
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
