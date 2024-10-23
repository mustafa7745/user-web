import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidget extends StatelessWidget {
  final double circleSize;
  final Color circleColor;
  final double spaceBetween;
  final double travelDistance;

  const LoadingWidget({
    Key? key,
    this.circleSize = 12.0,
    this.circleColor = Colors.blue,
    this.spaceBetween = 10.0,
    this.travelDistance = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("جاري المعالجة", style: TextStyle(fontSize: 10)),
        const SizedBox(height: 10),
        Divider(color: Colors.blue, thickness: 1),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Center(
              child: SizedBox(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildLoadingCircles(),
      ],
    );
  }

  Widget _buildLoadingCircles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          width: circleSize,
          height: circleSize,
          margin: EdgeInsets.symmetric(horizontal: spaceBetween),
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
          ),
          // You can animate the circles here if needed
        );
      }),
    );
  }
}
