import 'package:flutter/material.dart';

class Utang extends StatefulWidget {
  const Utang({Key? key}) : super(key: key);

  @override
  State<Utang> createState() => _UtangState();
}

class _UtangState extends State<Utang> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Utang Page"));
  }
}
