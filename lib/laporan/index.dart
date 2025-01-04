import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/components/spasi.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/laporan/laporan_buku_besar/index.dart';
import 'package:randu_mobile/laporan/laporan_jurnal/index.dart';
import 'package:randu_mobile/laporan/neraca/neraca_webview.dart';
import 'package:randu_mobile/laporan/neraca/new_index.dart';
import 'package:randu_mobile/laporan/neraca_saldo/index.dart';
import 'package:randu_mobile/laporan/profit_loss/index.dart';
import 'package:randu_mobile/laporan/profit_loss/profit_loss_webview.dart';
import 'package:randu_mobile/premium.dart';
import 'package:randu_mobile/premium_controller.dart';
import 'package:randu_mobile/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Laporan extends StatefulWidget {
  const Laporan({Key? key}) : super(key: key);

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  var now = DateTime.now();
  var formatter = DateFormat('MM');
  var formatterYear = DateFormat('yyyy');
  String thisMonth = "";
  String thisYear = "";

  List<String> laporan = [
    "Laporan Jurnal",
    "Laporan Buku Besar",
    "Neraca Saldo",
    "Laporan Laba Rugi",
    "Laporan Neraca"
  ];

  List<String> gambar = [
    "images/kalendar.png",
    "images/bukubesar.png",
    "images/neracasaldo.png",
    "images/labarugi.png",
    "images/neraca.png"
  ];

  _launchNeraca() async {
    String formattedDate = formatter.format(now);
    thisMonth = formattedDate.toString();
    String formattedYear = formatterYear.format(now);
    thisYear = formattedYear.toString();

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      Get.to(() => NeracaWebview(
            paymentUrl: Constant.BASE_URL +
                'neraca-webview/${userId}/${thisMonth}/${thisYear}/${thisMonth}/${thisYear}',
          ));
    }
  }

  _launchLabaRugi() async {
    String formattedDate = formatter.format(now);
    thisMonth = formattedDate.toString();
    String formattedYear = formatterYear.format(now);
    thisYear = formattedYear.toString();

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      Get.to(() => ProfitLossWebview(
            paymentUrl: Constant.BASE_URL +
                'profit-loss-webview/${userId}/${thisMonth}/${thisYear}/${thisMonth}/${thisYear}',
          ));
    }
  }

  _onTapReport(int index) {
    if (index == 0) {
      Get.to(() => const LaporanJurnal());
    } else if (index == 1) {
      Get.to(() => const BukuBesar());
    } else if (index == 2) {
      Get.to(() => const NeracaSaldo());
    } else if (index == 3) {
      // Get.to(() => const ProfitLoss());
      _launchLabaRugi();
    } else if (index == 4) {
      // Get.to(() => const Neraca());
      _launchNeraca();
    }
  }

  @override
  void initState() {
    PremiumController _premium = Get.put(PremiumController());
    _premium.cekPremium().then((value) {
      if (value) {
      } else {
        Get.to(() => const Premium());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: laporan.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _onTapReport(index);
                },
                child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(gambar[index],
                                width: 70, height: 70, fit: BoxFit.cover),
                            Spasi(lebar: 20),
                            Text(laporan[index],
                                style: const TextStyle(
                                    fontFamily: FontSetting.bold,
                                    fontSize: 16,
                                    color: Colors.white)),
                          ],
                        ),
                        const Icon(Icons.arrow_forward_rounded,
                            color: Colors.white)
                      ],
                    )),
              );
            }),
      ),
    );
  }
}
