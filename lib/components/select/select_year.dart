import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/journal/jurnal_controller.dart';

// ignore: must_be_immutable
class SelectYear extends StatelessWidget {
  String defValue;
  String label;
  List<DropdownMenuItem<String>> menuItems;
  SelectYear({
    Key? key,
    required this.defValue,
    required this.label,
    required this.menuItems,
  }) : super(key: key);

  final JurnalController _jurnalController = Get.put(JurnalController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
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
            _jurnalController.onYearChange(newValue.toString());
          },
          items: menuItems),
    );
  }
}
