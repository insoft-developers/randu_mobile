import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/journal/jurnal_controller.dart';

// ignore: must_be_immutable
class TextCari extends StatelessWidget {
  String hint;
  TextInputType textInputType;
  IconData iconData;
  TextEditingController textEditingController;
  bool obsecureText;
  final JurnalController _jurnalController = Get.put(JurnalController());

  TextCari(
      {Key? key,
      required this.hint,
      required this.textInputType,
      required this.iconData,
      required this.textEditingController,
      required this.obsecureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      height: 40,
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
          _jurnalController.searchJournalList(value);
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
              fontFamily: 'Rubik', fontSize: 15, color: Colors.grey),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
