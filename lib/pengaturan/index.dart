import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/components/spasi.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/pengaturan/hapus_saldo/index.dart';
import 'package:randu_mobile/pengaturan/kode_rekening/index.dart';

import 'package:randu_mobile/pengaturan/modal_awal/edit/index.dart';
import 'package:randu_mobile/pengaturan/modal_awal/tambah/index.dart';
import 'package:randu_mobile/pengaturan/opening_balance/index.dart';
import 'package:randu_mobile/pengaturan/pengaturan_controller.dart';

class Pengaturan extends StatefulWidget {
  const Pengaturan({Key? key}) : super(key: key);

  @override
  State<Pengaturan> createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  final PengaturanController _pengaturan = Get.put(PengaturanController());

  List<String> laporan = [
    "Pengaturan Modal Awal",
    "Pengaturan Kode Rekening",
    "Generate Opening Balance",
    "Hapus Saldo Awal",
  ];

  List<String> gambar = [
    "images/setting_awal.png",
    "images/setting_rekening.png",
    "images/setting_open.png",
    "images/setting_hapus.png",
  ];

  _onTapReport(int index) {
    if (index == 0) {
      _pengaturan.checkModal().then((value) => {
            if (value == 'exist')
              {
                Get.to(() => PengaturanModalAwal(
                      id: 20,
                    ))
              }
            else
              {
                Get.to(
                  () => const TambahModal(),
                )
              }
          });
    } else if (index == 1) {
      Get.to(() => const KodeRekening());
    } else if (index == 2) {
      Get.to(() => const OpeningBalance());
    } else if (index == 3) {
      Get.to(() => const HapusSaldo());
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
                        borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(gambar[index],
                                width: 70, height: 70, fit: BoxFit.cover),
                            Spasi(lebar: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 174,
                              child: Text(laporan[index],
                                  style: const TextStyle(
                                      fontFamily: FontSetting.bold,
                                      fontSize: 16,
                                      color: Colors.white)),
                            ),
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
