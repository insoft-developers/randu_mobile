import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/input_jurnal_shimmer.dart';
import 'package:randu_mobile/utang/hutang/history/history_controller.dart';
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
                  ? InputJurnalShimmer(tinggi: 200, jumlah: 10, pad: 0)
                  : _debtHistory.history.isEmpty
                      ? const Center(child: Text("Belum ada pembayaran"))
                      : ListView.builder(
                          itemCount: _debtHistory.history.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onLongPress: () {
                                if (_debtHistory.history[index]
                                        ['sync_status'] ==
                                    1) {
                                } else {
                                  showDialogSync(
                                      context,
                                      _debtHistory.history[index]['id']
                                          .toString(),
                                      widget.id);
                                }
                              },
                              child: Container(
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
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  2 -
                                              12,
                                          child: const Text("Tanggal",
                                              style: TextStyle(
                                                  fontFamily: FontSetting.reg)),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  2 -
                                              40,
                                          child: Text(
                                              Tanggal.getOnlyDate(_debtHistory
                                                  .history[index]['created_at']
                                                  .toString()),
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  fontFamily:
                                                      FontSetting.bold)),
                                        )
                                      ],
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
                                                  2 -
                                              12,
                                          child: const Text("Bayar dari",
                                              style: TextStyle(
                                                  fontFamily: FontSetting.reg)),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  2 -
                                              40,
                                          child: Text(
                                              _debtHistory.history[index]
                                                      ['payment_from']
                                                  .toString(),
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  fontFamily:
                                                      FontSetting.bold)),
                                        )
                                      ],
                                    ),
                                    Jarak(tinggi: 2),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  2 -
                                              12,
                                          child: const Text("Bayar Untuk",
                                              style: TextStyle(
                                                  fontFamily: FontSetting.reg)),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  2 -
                                              40,
                                          child: Text(
                                              _debtHistory.history[index]
                                                      ['payment_to']
                                                  .toString(),
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  fontFamily:
                                                      FontSetting.bold)),
                                        )
                                      ],
                                    ),
                                    Jarak(tinggi: 2),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  2 -
                                              12,
                                          child: const Text("Nominal Bayar",
                                              style: TextStyle(
                                                  fontFamily: FontSetting.reg)),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  2 -
                                              40,
                                          child: Text(
                                              Ribuan.formatAngka(_debtHistory
                                                  .history[index]['amount']
                                                  .toString()),
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  fontFamily:
                                                      FontSetting.bold)),
                                        )
                                      ],
                                    ),
                                    Jarak(tinggi: 2),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  2 -
                                              12,
                                          child: const Text("Sisa Utang",
                                              style: TextStyle(
                                                  fontFamily: FontSetting.reg)),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  2 -
                                              40,
                                          child: Text(
                                              Ribuan.formatAngka(_debtHistory
                                                  .history[index]['balance']
                                                  .toString()),
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  fontFamily:
                                                      FontSetting.bold)),
                                        )
                                      ],
                                    ),
                                    Jarak(tinggi: 2),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  2 -
                                              12,
                                          child: const Text("Keterangan",
                                              style: TextStyle(
                                                  fontFamily: FontSetting.reg)),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
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
                                                  fontFamily:
                                                      FontSetting.bold)),
                                        )
                                      ],
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
                                                  2 -
                                              12,
                                          child: const Text("Sync Status",
                                              style: TextStyle(
                                                  fontFamily: FontSetting.reg)),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  2 -
                                              40,
                                          child: _debtHistory.history[index]
                                                      ['sync_status'] ==
                                                  1
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: const [
                                                    Icon(Icons.check,
                                                        color: AppColor.hijau),
                                                    Text("Synced",
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                            color:
                                                                AppColor.hijau,
                                                            fontFamily:
                                                                FontSetting
                                                                    .bold)),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: const [
                                                    Icon(Icons.sync_disabled,
                                                        color: AppColor.merah),
                                                    Text("not Sync",
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                            color:
                                                                AppColor.merah,
                                                            fontFamily:
                                                                FontSetting
                                                                    .bold)),
                                                  ],
                                                ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
            )));
  }
}

showDialogSync(BuildContext context, String paymentId, String hutangId) {
  Widget cancelButton = TextButton(
    child: const Text(
      "Tidak",
      style: TextStyle(fontFamily: 'PoppinsBold'),
    ),
    onPressed: () {
      Get.back();
    },
  );

  Widget continueButton = TextButton(
    child: const Text(
      "Sync Data ?",
      style: TextStyle(fontFamily: 'PoppinsBold'),
    ),
    onPressed: () {
      DebtHistoryController _history = Get.put(DebtHistoryController());
      _history.paymentSync(paymentId, hutangId);
    },
  );

  AlertDialog alert = AlertDialog(
    title:
        const Text("Peringatan", style: TextStyle(fontFamily: 'PoppinsBold')),
    content: const Text('Sinkronisasi data ini ke jurnal..? ',
        style: TextStyle(fontFamily: 'Poppins')),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
