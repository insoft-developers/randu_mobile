import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/journal/jurnal_controller.dart';
import 'package:randu_mobile/laporan/laporan_buku_besar/buku_besar_controller.dart';
import 'package:randu_mobile/laporan/laporan_jurnal/laporan_jurnal_controller.dart';
import 'package:randu_mobile/laporan/neraca/neraca_controller.dart';
import 'package:randu_mobile/laporan/neraca_saldo/neraca_saldo_controller.dart';
import 'package:randu_mobile/laporan/profit_loss/profit_loss_controller.dart';

// ignore: must_be_immutable
class SelectYearReport extends StatelessWidget {
  String defValue;
  String label;
  List<DropdownMenuItem<String>> menuItems;
  String code;
  SelectYearReport(
      {Key? key,
      required this.defValue,
      required this.label,
      required this.menuItems,
      required this.code})
      : super(key: key);

  _onChange(String value) {
    if (code == 'laporan-jurnal') {
      final LaporanJurnalController _laporanJurnal =
          Get.put(LaporanJurnalController());
      _laporanJurnal.thisYear.value = value;
    } else if (code == 'buku-besar') {
      final BukuBesarController _laporan = Get.put(BukuBesarController());
      _laporan.thisYear.value = value;
    } else if (code == 'neraca-saldo') {
      final NeracaSaldoController _neracaSaldo =
          Get.put(NeracaSaldoController());
      _neracaSaldo.thisYear.value = value;
    } else if (code == 'profit-loss') {
      final ProfitLossController _laporan = Get.put(ProfitLossController());
      _laporan.thisYear.value = value;
    }else if (code == 'balance-sheet') {
      final NeracaController _laporan = Get.put(NeracaController());
      _laporan.thisYear.value = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonFormField(
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          value: defValue,
          onChanged: (String? newValue) {
            _onChange(newValue.toString());
          },
          items: menuItems),
    );
  }
}
