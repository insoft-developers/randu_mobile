import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/laporan/laporan_buku_besar/buku_besar_controller.dart';
import 'package:randu_mobile/laporan/laporan_jurnal/laporan_jurnal_controller.dart';
import 'package:randu_mobile/laporan/neraca/neraca_controller.dart';
import 'package:randu_mobile/laporan/neraca_saldo/neraca_saldo_controller.dart';
import 'package:randu_mobile/laporan/profit_loss/profit_loss_controller.dart';
import 'package:randu_mobile/pengaturan/hapus_saldo/hapus_saldo_controller.dart';
import 'package:randu_mobile/pengaturan/opening_balance/opening_balance_controller.dart';
import 'package:randu_mobile/penyusutan/penyusutan_controller.dart';
import 'package:randu_mobile/utang/hutang/hutang_controller.dart';
import 'package:randu_mobile/utang/piutang/piutang_controller.dart';

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
    } else if (code == 'balance-sheet') {
      final NeracaController _laporan = Get.put(NeracaController());
      _laporan.thisYear.value = value;
    } else if (code == 'debt-list') {
      final HutangController _hutang = Get.put(HutangController());
      _hutang.yearOnChange(value);
    } else if (code == 'piutang-list') {
      final PiutangController _piutang = Get.put(PiutangController());
      _piutang.yearOnChange(value);
    } else if (code == 'penyusutan-list') {
      final PenyusutanController _penyusutan = Get.put(PenyusutanController());
      _penyusutan.yearOnChange(value);
    } else if (code == 'opening-balance') {
      final OpeningBalanceController _opening = OpeningBalanceController();
      _opening.thisYear.value = value;
    } else if (code == 'hapus-saldo') {
      final HapusSaldoController _hapusSaldo = Get.put(HapusSaldoController());
      _hapusSaldo.thisYear.value = value;
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
