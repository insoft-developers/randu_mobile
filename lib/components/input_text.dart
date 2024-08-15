import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/journal/tambah/jurnal_cepat/jurnal_cepat_controller.dart';

// ignore: must_be_immutable
class InputText extends StatelessWidget {
  String hint;
  TextInputType textInputType;
  TextEditingController textEditingController;
  bool obsecureText;
  String code;

  final JurnalCepatController _jurnalCepatController =
      Get.put(JurnalCepatController());

  InputText(
      {Key? key,
      required this.hint,
      required this.textInputType,
      required this.textEditingController,
      required this.obsecureText,
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
        obscureText: obsecureText,
        keyboardType: textInputType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
              fontFamily: 'Rubik', fontSize: 15, color: Colors.grey),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: (value) {
          if (code == 'journal-nominal') {
            _jurnalCepatController
                .setRibuan(value.isEmpty ? 0 : int.parse(value));
          }
        },
      ),
    );
  }
}
