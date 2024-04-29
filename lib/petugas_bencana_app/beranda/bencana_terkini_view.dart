import 'package:flutter/material.dart';
import 'dart:math' as math;

class MediterranesnDietView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const MediterranesnDietView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: <Widget>[
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(100.0),
                                        border: Border.all(
                                          width: 4,
                                          color: Colors.red.withOpacity(0.5),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${(80 * animation!.value).toInt()}%',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 20,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -20,
                                      right: -20,
                                      child: CustomPaint(
                                        painter: CurvePainter(
                                          colors: [
                                            Color(0xFF2633C5),
                                            Color(0xFFe42a46),
                                            Color(0xFFe42a46)
                                          ],
                                          angle: 300 + (360 - 300) * (1.0 - animation!.value),
                                        ),
                                        child: SizedBox(
                                          width: 120,
                                          height: 120,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Kebakaran Hutan',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Kebakaran hutan terjadi di pahae dan sekitarnya, mohon untuk berhati hati dan gunakan helm.',
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CurvePainter extends CustomPainter {
  final double? angle;
  final List<Color>? colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    // Painting logic here
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    return (math.pi / 180) * degree;
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: MediterranesnDietView(),
    ),
  ));
}
