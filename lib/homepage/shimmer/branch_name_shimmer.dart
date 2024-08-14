import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class BranchNameShimmer extends StatelessWidget {
  double lebar;
  double tinggi;
  BranchNameShimmer({Key? key, required this.lebar, required this.tinggi})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: tinggi,
          width: lebar,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
        ));
  }
}
