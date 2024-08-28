import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/homepage.dart';
import 'package:randu_mobile/homepage/shimmer/input_jurnal_shimmer.dart';
import 'package:randu_mobile/utang/hutang/history/history_controller.dart';
import 'package:randu_mobile/utang/hutang/index.dart';
import 'package:randu_mobile/utils/ribuan.dart';
import 'package:randu_mobile/utils/tanggal.dart';

// ignore: must_be_immutable
class DebtHistory extends StatefulWidget {
  String id;
  DebtHistory({Key? key, required this.id}) : super(key: key);

  @override
  State<DebtHistory> createState() => _DebtHistoryState();
}

class _DebtHistoryState extends State<DebtHistory> {
  final DebtHistoryController _debtHistory = Get.put(DebtHistoryController());

  @override
  void initState() {
    _debtHistory.getHistoryById(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: const Text("History Hutang"),
        ),
        body: Container(
            margin: const EdgeInsets.all(10),
            child: Obx(
              () => _debtHistory.loading.value
                  ? InputJurnalShimmer(tinggi: 150, jumlah: 10, pad: 0)
                  : _debtHistory.history.isEmpty
                      ? const Center(child: Text("Belum ada pembayaran"))
                      : ListView.builder(
                          itemCount: _debtHistory.history.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppColor.displayLine),
                                  color: AppColor.display),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    1 /
                                                    2 -
                                                12,
                                        child: const Text("Tanggal",
                                            style: TextStyle(
                                                fontFamily: FontSetting.reg)),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    1 /
                                                    2 -
                                                40,
                                        child: Text(
                                            Tanggal.getOnlyDate(_debtHistory
                                                .history[index]['created_at']
                                                .toString()),
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                fontFamily: FontSetting.bold)),
                                      )
                                    ],
                                  ),
                                  Jarak(tinggi: 2),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    1 /
                                                    2 -
                                                12,
                                        child: const Text("Bayar dari",
                                            style: TextStyle(
                                                fontFamily: FontSetting.reg)),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    1 /
                                                    2 -
                                                40,
                                        child: Text(
                                            _debtHistory.history[index]
                                                    ['payment_from']
                                                .toString(),
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                fontFamily: FontSetting.bold)),
                                      )
                                    ],
                                  ),
                                  Jarak(tinggi: 2),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    1 /
                                                    2 -
                                                12,
                                        child: const Text("Bayar Untuk",
                                            style: TextStyle(
                                                fontFamily: FontSetting.reg)),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    1 /
                                                    2 -
                                                40,
                                        child: Text(
                                            _debtHistory.history[index]
                                                    ['payment_to']
                                                .toString(),
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                fontFamily: FontSetting.bold)),
                                      )
                                    ],
                                  ),
                                  Jarak(tinggi: 2),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    1 /
                                                    2 -
                                                12,
                                        child: const Text("Nominal Bayar",
                                            style: TextStyle(
                                                fontFamily: FontSetting.reg)),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    1 /
                                                    2 -
                                                40,
                                        child: Text(
                                            Ribuan.formatAngka(_debtHistory
                                                .history[index]['amount']
                                                .toString()),
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                fontFamily: FontSetting.bold)),
                                      )
                                    ],
                                  ),
                                  Jarak(tinggi: 2),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    1 /
                                                    2 -
                                                12,
                                        child: const Text("Sisa Utang",
                                            style: TextStyle(
                                                fontFamily: FontSetting.reg)),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    1 /
                                                    2 -
                                                40,
                                        child: Text(
                                            Ribuan.formatAngka(_debtHistory
                                                .history[index]['balance']
                                                .toString()),
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                fontFamily: FontSetting.bold)),
                                      )
                                    ],
                                  ),
                                  Jarak(tinggi: 2),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    1 /
                                                    2 -
                                                12,
                                        child: const Text("Keterangan",
                                            style: TextStyle(
                                                fontFamily: FontSetting.reg)),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    1 /
                                                    2 -
                                                40,
                                        child: Text(
                                            _debtHistory.history[index]
                                                        ['note'] !=
                                                    null
                                                ? _debtHistory.history[index]
                                                        ['note']
                                                    .toString()
                                                : "",
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                fontFamily: FontSetting.bold)),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
            )));
  }

  // Future<bool> _onWillPop() async {
  //   return (await showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text(
  //             'Kembali Ke Menu',
  //             style: TextStyle(fontFamily: 'PoppinsBold'),
  //           ),
  //           content: const Text('Kembali Ke Daftar Hutang..? ',
  //               style: TextStyle(fontFamily: 'Poppins')),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () => Get.back(),
  //               child: const Text('Tidak',
  //                   style: TextStyle(fontFamily: 'PoppinsBold')),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Get.offAll(() => const HomePage());
  //               },
  //               child: const Text('Ya',
  //                   style: TextStyle(fontFamily: 'PoppinsBold')),
  //             ),
  //           ],
  //         ),
  //       )) ??
  //       false;
  // }
}
