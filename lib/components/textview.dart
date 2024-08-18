import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextView extends StatelessWidget {
  String hint;
  TextInputType textInputType;
  IconData iconData;
  TextEditingController textEditingController;
  bool obsecureText;

  TextView(
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
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.transparent,
        border: Border.all(color: Colors.white, width: 1.0),
      ),
      child: TextField(
        controller: textEditingController,
        obscureText: obsecureText,
        keyboardType: textInputType,
        textInputAction: TextInputAction.next,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: SizedBox(
            height: 30,
            width: 30,
            child: Icon(iconData, color: Colors.white),
          ),
          hintText: hint,
          hintStyle: const TextStyle(
              fontFamily: 'Rubik', fontSize: 15, color: Colors.white),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
