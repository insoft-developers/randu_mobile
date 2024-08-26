import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/components/spasi.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/utang/hutang/index.dart';

class Utang extends StatefulWidget {
  const Utang({Key? key}) : super(key: key);

  @override
  State<Utang> createState() => _UtangState();
}

class _UtangState extends State<Utang> {
  List<String> laporan = [
    "Daftar Hutang",
    "Daftar Piutang",
  ];

  List<String> gambar = [
    "images/hutang.png",
    "images/piutang.png",
  ];

  _onTapReport(int index) {
    if (index == 0) {
      Get.to(() => const Hutang());
    } else if (index == 1) {}
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
                        borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(gambar[index],
                                width: 70, height: 160, fit: BoxFit.contain),
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
