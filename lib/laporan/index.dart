import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/components/spasi.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/laporan/laporan_buku_besar/index.dart';
import 'package:randu_mobile/laporan/laporan_jurnal/index.dart';
import 'package:randu_mobile/laporan/neraca_saldo/index.dart';

class Laporan extends StatefulWidget {
  const Laporan({Key? key}) : super(key: key);

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
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

  _onTapReport(int index) {
    if (index == 0) {
      Get.to(() => const LaporanJurnal());
    } else if (index == 1) {
      Get.to(() => const BukuBesar());
    } else if (index == 2) {
      Get.to(() => const NeracaSaldo());
    }
  }

  @override
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
                        gradient: AppColor.blueGradient,
                        borderRadius: BorderRadius.circular(4)),
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
