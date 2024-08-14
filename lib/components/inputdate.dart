import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/journal/tambah/jurnal_cepat/jurnal_cepat_controller.dart';

// ignore: must_be_immutable
class InputDate extends StatelessWidget {
  final TextEditingController textEditingController;
  final JurnalCepatController _jurnalCepatController =
      Get.put(JurnalCepatController());

  String hint;
  String title;
  InputDate(
      {Key? key,
      required this.textEditingController,
      required this.hint,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(4)),
      height: 50,
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: hint,
          label: Text(title),
          border: InputBorder.none,
          filled: false,
          suffixIcon: const Icon(Icons.calendar_month),
        ),
        readOnly: true,
        onTap: () {},
      ),
    );
  }
}
