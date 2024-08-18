import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class InputJurnalShimmer extends StatelessWidget {
  double tinggi;
  int jumlah;
  double pad;
  InputJurnalShimmer(
      {Key? key, required this.tinggi, required this.jumlah, required this.pad})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: pad),
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
