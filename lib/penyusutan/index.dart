import 'package:flutter/material.dart';

class Penyusutan extends StatefulWidget {
  const Penyusutan({Key? key}) : super(key: key);

  @override
  State<Penyusutan> createState() => _PenyusutanState();
}

class _PenyusutanState extends State<Penyusutan> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Penyusutan Page"));
  }
}
