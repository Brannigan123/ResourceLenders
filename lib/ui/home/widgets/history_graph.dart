import 'package:cash_pump/models/withdrawal.dart';
import 'package:flutter/material.dart';

class HistoryGraph extends StatelessWidget {
  const HistoryGraph({
    Key? key,
    required this.withdrawals,
  }) : super(key: key);

  final ValueNotifier<List<Withdrawal>> withdrawals;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        return Container(
          width: width,
          height: height,
          child: ValueListenableBuilder<List<Withdrawal>>(
            valueListenable: withdrawals,
            builder: (context, value, child) {
              return CustomPaint(
                size: Size(width, height),
                painter: GraphPainter(),
              );
            },
          ),
        );
      },
    );
  }
}

class GraphPainter extends CustomPainter {
  // final List<double> x;
  // final List<double> y;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0.0, size.height);
    final Path path = new Path();
    final Paint paint = new Paint();
    paint.color = Colors.blue;
    final double center = size.height / 2;
    path.moveTo(0.0, 0.0); // first point in bottom left corner of container
    List<double> ypos = [
      10.0,
      40.0,
      100.0,
      60.0,
      40.0,
      55.0,
      200.0
    ]; // random y points
    path.lineTo(
        0.0,
        -(ypos[0] +
            center)); // creates a point translated in y inline with leading edge
    final int dividerCnst = ypos.length; // number of points in graph
    for (int i = 1; i < dividerCnst + 1; i++) {
      path.lineTo(size.width / dividerCnst * i - size.width / (dividerCnst * 2),
          -(ypos[i - 1] + center));
    }
    path.lineTo(
        size.width,
        -(ypos[dividerCnst - 1] +
            center)); // the last pont in line with trailing edge
    path.lineTo(
        size.width, 0.0); // last point in bottom right corner of container
    path.close();
    canvas.drawPath(path, paint);
// canvas.restore();
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(GraphPainter oldDelegate) => false;
}
//