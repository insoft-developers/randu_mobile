import 'package:flutter/material.dart';

class Spasi extends StatelessWidget {
  double lebar;
  Spasi({Key? key, required this.lebar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: lebar,
    );
  }
}
