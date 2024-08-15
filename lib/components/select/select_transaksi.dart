import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/journal/tambah/jurnal_cepat/jurnal_cepat_controller.dart';

// ignore: must_be_immutable
class SelectTransaksi extends StatelessWidget {
  String defValue;
  String label;
  List<DropdownMenuItem<String>> menuItems;
  final JurnalCepatController _jurnalCepatController =
      Get.put(JurnalCepatController());

  SelectTransaksi({
    Key? key,
    required this.defValue,
    required this.label,
    required this.menuItems,
  }) : super(key: key);

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
            _jurnalCepatController.onChangeTransaction(newValue.toString());
          },
          items: menuItems),
    );
  }
}
