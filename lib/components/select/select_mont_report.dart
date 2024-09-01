import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/laporan/laporan_buku_besar/buku_besar_controller.dart';
import 'package:randu_mobile/laporan/laporan_jurnal/laporan_jurnal_controller.dart';
import 'package:randu_mobile/laporan/neraca/neraca_controller.dart';
import 'package:randu_mobile/laporan/neraca_saldo/neraca_saldo_controller.dart';
import 'package:randu_mobile/laporan/profit_loss/profit_loss_controller.dart';
import 'package:randu_mobile/penyusutan/penyusutan_controller.dart';
import 'package:randu_mobile/penyusutan/tambah/tambah_penyusutan_controller.dart';
import 'package:randu_mobile/utang/hutang/hutang_controller.dart';
import 'package:randu_mobile/utang/hutang/tambah/tambah_hutang_controller.dart';
import 'package:randu_mobile/utang/piutang/pembayaran/piutang_payment_controller.dart';
import 'package:randu_mobile/utang/piutang/piutang_controller.dart';
import 'package:randu_mobile/utang/piutang/tambah/tambah_piutang_controller.dart';

// ignore: must_be_immutable
class SelectMonthReport extends StatelessWidget {
  String defValue;
  String label;
  List<DropdownMenuItem<String>> menuItems;
  String code;
  SelectMonthReport({
    Key? key,
    required this.defValue,
    required this.label,
    required this.menuItems,
    required this.code,
  }) : super(key: key);

  _onChange(String value) {
    if (code == 'laporan-jurnal') {
      final LaporanJurnalController _laporanJurnal =
          Get.put(LaporanJurnalController());
      _laporanJurnal.thisMonth.value = value;
    } else if (code == 'buku-besar') {
      final BukuBesarController _laporanJurnal = Get.put(BukuBesarController());
      _laporanJurnal.thisMonth.value = value;
    } else if (code == 'neraca-saldo') {
      final NeracaSaldoController _neracaSaldo =
          Get.put(NeracaSaldoController());
      _neracaSaldo.thisMonth.value = value;
    } else if (code == 'profit-loss') {
      final ProfitLossController _laporan = Get.put(ProfitLossController());
      _laporan.thisMonth.value = value;
    } else if (code == 'balance-sheet') {
      final NeracaController _laporan = Get.put(NeracaController());
      _laporan.thisMonth.value = value;
    } else if (code == 'debt-category') {
      final HutangController _hutang = Get.put(HutangController());
      _hutang.categoryOnChange(value);
    } else if (code == 'debt-list') {
      final HutangController _hutang = Get.put(HutangController());
      _hutang.monthOnChange(value);
    } else if (code == 'tambah-hutang') {
      final TambahHutangController _thc = Get.put(TambahHutangController());
      _thc.onChangeCategory(value);
    } else if (code == 'debt-sub-category') {
      final TambahHutangController _thc = Get.put(TambahHutangController());
      _thc.selectedSub.value = value;
    } else if (code == 'debt-from') {
      final TambahHutangController _thc = Get.put(TambahHutangController());
      _thc.selectedDebtFrom.value = value;
    } else if (code == 'debt-to') {
      final TambahHutangController _thc = Get.put(TambahHutangController());
      _thc.selectedDebtTo.value = value;
    }
    // ========================================================================
    else if (code == 'piutang-category') {
      final PiutangController _piutang = Get.put(PiutangController());
      _piutang.categoryOnChange(value);
    } else if (code == 'piutang-list') {
      final PiutangController _piutang = Get.put(PiutangController());
      _piutang.monthOnChange(value);
    } else if (code == 'tambah-piutang') {
      final TambahPiutangController _thc = Get.put(TambahPiutangController());
      _thc.onChangeCategory(value);
    } else if (code == 'piutang-sub-category') {
      final TambahPiutangController _thc = Get.put(TambahPiutangController());
      _thc.selectedSub.value = value;
    } else if (code == 'piutang-from') {
      final TambahPiutangController _thc = Get.put(TambahPiutangController());
      _thc.selectedPiutangFrom.value = value;
    } else if (code == 'piutang-to') {
      final TambahPiutangController _thc = Get.put(TambahPiutangController());
      _thc.selectedPiutangTo.value = value;
    } else if (code == 'bayar-ke') {
      final PiutangPaymentController _thc = Get.put(PiutangPaymentController());
      _thc.selectedBayarKe.value = value;
    } else if (code == 'penyusutan-category') {
      final PenyusutanController _thc = Get.put(PenyusutanController());
      _thc.categoryOnChange(value);
    } else if (code == 'penyusutan-list') {
      final PenyusutanController _penyusutan = Get.put(PenyusutanController());
      _penyusutan.monthOnChange(value);
    } else if (code == 'tambah-penyusutan') {
      final TambahPenyusutanController _tpc =
          Get.put(TambahPenyusutanController());
      _tpc.onCategoryChange(value);
    } else if (code == 'akumulasi-penyusutan') {
      final TambahPenyusutanController _tpc =
          Get.put(TambahPenyusutanController());
      _tpc.selectedAkumulasi.value = value;
    } else if (code == 'beban-penyusutan') {
      final TambahPenyusutanController _tpc =
          Get.put(TambahPenyusutanController());
      _tpc.selectedBeban.value = value;
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
