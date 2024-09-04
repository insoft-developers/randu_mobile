import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/journal/tambah/jurnal_cepat/jurnal_cepat_controller.dart';
import 'package:randu_mobile/penyusutan/tambah/tambah_penyusutan_controller.dart';
import 'package:randu_mobile/utang/hutang/pembayaran/debt_payment_controller.dart';
import 'package:randu_mobile/utang/hutang/tambah/tambah_hutang_controller.dart';
import 'package:randu_mobile/utang/piutang/pembayaran/piutang_payment_controller.dart';
import 'package:randu_mobile/utang/piutang/tambah/tambah_piutang_controller.dart';

// ignore: must_be_immutable
class InputReadOnly extends StatelessWidget {
  String hint;
  TextInputType textInputType;
  TextEditingController textEditingController;
  String code;

  InputReadOnly(
      {Key? key,
      required this.hint,
      required this.textInputType,
      required this.textEditingController,
      required this.code})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 0.5),
        boxShadow: const [
          BoxShadow(offset: Offset(0, 1), blurRadius: 50, color: Colors.white),
        ],
      ),
      child: TextField(
        controller: textEditingController,
        obscureText: false,
        readOnly: true,
        keyboardType: textInputType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
              fontFamily: 'Rubik', fontSize: 15, color: Colors.grey),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: (value) {},
      ),
    );
  }
}
