import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputDate extends StatelessWidget {
  final TextEditingController textEditingController;
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
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      height: 40,
      child: TextField(
        controller:
            textEditingController, //editing controller of this TextField
        decoration: InputDecoration(
          hintText: hint,
          label: Text(title),
          border: InputBorder.none,
          filled: false,
          suffixIcon: const Icon(Icons.calendar_month),
        ),

        readOnly: true, //set it true, so that user will not able to edit text
        onTap: () {
          // _realisasiController.getTransactionDate().then((value) {
          //   textEditingController.text = value.toString();
        },
      ),
    );
  }
}
