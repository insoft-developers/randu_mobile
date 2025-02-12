import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_mont_report.dart';
import 'package:randu_mobile/components/select/select_year_report.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/laporan/neraca/neraca_controller.dart';
import 'package:randu_mobile/laporan/neraca/neraca_webview.dart';
import 'package:randu_mobile/laporan/neraca/neraca_webview2.dart';
import 'package:randu_mobile/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class NeracaWebview2 extends StatefulWidget {
  String paymentUrl;
  NeracaWebview2({Key? key, required this.paymentUrl}) : super(key: key);

  @override
  State<NeracaWebview2> createState() => _NeracaWebview2State();
}

class _NeracaWebview2State extends State<NeracaWebview2> {
  NeracaController _laporan = Get.put(NeracaController());
  double _progress = 0;
  late InAppWebViewController webView;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: const Text("Laporan Neraca"),
          actions: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _laporan.exportExcel();
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
                    _laporan.exportPdf();
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
            ),
          ]),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
            backgroundColor: AppColor.mainColor,
            child: const Icon(Icons.calendar_month),
            onPressed: () async {
              SharedPreferences localStorage =
                  await SharedPreferences.getInstance();
              var user = jsonDecode(localStorage.getString('user')!);
              if (user != null) {
                String userId = user['id'].toString();
                _showSimpleModalDialog(context, userId);
              }
            }),
      ),
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
                url: Uri.parse(
              widget.paymentUrl,
            )),
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  mediaPlaybackRequiresUserGesture: false,
                ),
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                ),
                ios: IOSInAppWebViewOptions(
                  allowsInlineMediaPlayback: true,
                )),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
          ),
          _progress < 1
              ? SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.2),
                  ))
              : const SizedBox(),
        ],
      ),
    );
  }
}

Future<void> _showSimpleModalDialog(context, String userId) async {
  final NeracaController _laporanController = Get.put(NeracaController());
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 350),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Jarak(tinggi: 15),
                  const Text(
                    "Periode Dari",
                    style: TextStyle(fontFamily: FontSetting.bold),
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
                            code: "balance-sheet")),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 1 / 3 + 3,
                        child: Obx(() => SelectYearReport(
                            defValue: _laporanController.thisYear.value,
                            label: "Tahun",
                            menuItems: _laporanController.yearDropdown,
                            code: "balance-sheet")),
                      ),
                    ],
                  ),
                  Jarak(tinggi: 15),
                  const Text(
                    "Periode Sampai",
                    style: TextStyle(fontFamily: FontSetting.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 1 / 3 + 3,
                        child: Obx(() => SelectMonthReport(
                            defValue: _laporanController.thisMonthTo.value,
                            label: "Bulan",
                            menuItems: _laporanController.monthDropdown,
                            code: "balance-sheet-akhir")),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 1 / 3 + 3,
                        child: Obx(() => SelectYearReport(
                            defValue: _laporanController.thisYearTo.value,
                            label: "Tahun",
                            menuItems: _laporanController.yearDropdown,
                            code: "balance-sheet-akhir")),
                      ),
                    ],
                  ),
                  Jarak(tinggi: 40),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      Get.back();
                      Get.to(() => NeracaWebview(
                          paymentUrl: Constant.BASE_URL +
                              'neraca-webview/${userId}/${_laporanController.thisMonth.value}/${_laporanController.thisYear.value}/${_laporanController.thisMonthTo.value}/${_laporanController.thisYearTo.value}'));
                    },
                    child: Center(
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                              color: AppColor.mainColor,
                              borderRadius: BorderRadius.circular(4)),
                          child: const Text("Submit",
                              style: TextStyle(color: AppColor.putih))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
