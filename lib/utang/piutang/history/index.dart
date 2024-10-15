import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/input_jurnal_shimmer.dart';
import 'package:randu_mobile/utang/piutang/history/piutang_history_controller.dart';
import 'package:randu_mobile/utils/ribuan.dart';
import 'package:randu_mobile/utils/tanggal.dart';

// ignore: must_be_immutable
class PiutangHistory extends StatefulWidget {
  String id;
  PiutangHistory({Key? key, required this.id}) : super(key: key);

  @override
  State<PiutangHistory> createState() => _PiutangHistoryState();
}

class _PiutangHistoryState extends State<PiutangHistory> {
  final PiutangHistoryController _piutangHistory =
      Get.put(PiutangHistoryController());

  @override
  void initState() {
    _piutangHistory.getHistoryById(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: const Text("History Piutang"),
        ),
        body: Container(
            margin: const EdgeInsets.all(10),
            child: Obx(
              () => _piutangHistory.loading.value
                  ? InputJurnalShimmer(tinggi: 200, jumlah: 10, pad: 0)
                  : _piutangHistory.history.isEmpty
                      ? const Center(child: Text("Belum ada pembayaran"))
                      : ListView.builder(
                          itemCount: _piutangHistory.history.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onLongPress: () {
                                if (_piutangHistory.history[index]
                                        ['sync_status'] ==
                                    1) {
                                } else {
                                  showDialogSync(
                                      context,
                                      _piutangHistory.history[index]['id']
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
                                              Tanggal.getOnlyDate(
                                                  _piutangHistory.history[index]
                                                          ['created_at']
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
                                              _piutangHistory.history[index]
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
                                              _piutangHistory.history[index]
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
                                              Ribuan.formatAngka(_piutangHistory
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
                                              Ribuan.formatAngka(_piutangHistory
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
                                              _piutangHistory.history[index]
                                                          ['note'] !=
                                                      null
                                                  ? _piutangHistory
                                                      .history[index]['note']
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
                                          child: _piutangHistory.history[index]
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
      PiutangHistoryController _history = Get.put(PiutangHistoryController());
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
