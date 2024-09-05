import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/journal/jurnal_controller.dart';
import 'package:randu_mobile/utang/hutang/hutang_controller.dart';
import 'package:randu_mobile/utang/piutang/piutang_controller.dart';

// ignore: must_be_immutable
class InputSearch extends StatelessWidget {
  String hint;
  TextInputType textInputType;
  IconData iconData;
  TextEditingController textEditingController;
  bool obsecureText;
  final JurnalController _jurnalController = Get.put(JurnalController());
  String code;

  InputSearch(
      {Key? key,
      required this.hint,
      required this.textInputType,
      required this.iconData,
      required this.textEditingController,
      required this.obsecureText,
      required this.code})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.transparent,
        border: Border.all(color: Colors.grey, width: 0.5),
        boxShadow: const [
          BoxShadow(offset: Offset(0, 1), blurRadius: 50, color: Colors.white),
        ],
      ),
      child: TextField(
        controller: textEditingController,
        onChanged: (value) {
          if (code == 'debt-search') {
            HutangController _hc = Get.put(HutangController());
            _hc.onSearchDebt(value);
          } else if (code == 'piutang-search') {
            PiutangController _hc = Get.put(PiutangController());
            _hc.onSearchPiutang(value);
          }
        },
        obscureText: obsecureText,
        keyboardType: textInputType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          icon: SizedBox(
            height: 30,
            width: 30,
            child: Icon(iconData, color: Colors.blue[900]),
          ),
          hintText: hint,
          hintStyle: const TextStyle(
              fontFamily: FontSetting.reg, fontSize: 15, color: Colors.grey),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
