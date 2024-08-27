import 'package:flutter/material.dart';
import 'package:randu_mobile/css/font_setting.dart';

// ignore: must_be_immutable
class TextArea extends StatelessWidget {
  String hint;
  int maxline;

  TextEditingController textEditingController;

  TextArea(
      {Key? key,
      required this.hint,
      required this.textEditingController,
      required this.maxline})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 54),
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.transparent,
        border: Border.all(color: Colors.grey.withOpacity(0.7)),
        boxShadow: const [
          BoxShadow(offset: Offset(0, 1), blurRadius: 50, color: Colors.white),
        ],
      ),
      child: TextField(
        controller: textEditingController,
        obscureText: false,
        keyboardType: TextInputType.multiline,
        maxLines: maxline,
        decoration: InputDecoration(
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
