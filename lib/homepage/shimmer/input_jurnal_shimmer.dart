import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class InputJurnalShimmer extends StatelessWidget {
  double tinggi;
  int jumlah;
  InputJurnalShimmer({Key? key, required this.tinggi, required this.jumlah})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: jumlah,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: tinggi,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white),
                );
              }),
        ));
  }
}
