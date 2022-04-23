import 'package:flutter/material.dart';

class AnimatedGradient extends StatefulWidget {
  final Widget child;
  AnimatedGradient({required this.child});
  @override
  _AnimatedGradientState createState() => _AnimatedGradientState();
}

class _AnimatedGradientState extends State<AnimatedGradient> {
  List<Color> colorList = [
    Color(0xff125B50),
   Color(0xff4E944F),
    Color(0xff125B50),
    Color(0xff069A8E),
    Color(0xff069A8E)
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  Color bottomColor = Color(0xff125B50);
  Color topColor = Color(0xff069A8E);
  Alignment begin = Alignment.bottomRight;
  Alignment end = Alignment.topRight;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        topColor = Color(0xff125B50);

      });
    });
    return Scaffold(
        body: Stack(
      children: [
        AnimatedContainer(
          duration: Duration(seconds: 1),
          onEnd: () {
            setState(() {
              index = index + 2;
              // animate the color
              bottomColor = colorList[index % colorList.length];
              topColor = colorList[(index + 2) % colorList.length];

              //// animate the alignment
              // begin = alignmentList[index % alignmentList.length];
              // end = alignmentList[(index + 2) % alignmentList.length];
            });
          },
          decoration: BoxDecoration(
              gradient: LinearGradient(
                
                  begin: begin,
                  end: end,
                  colors: [bottomColor, topColor, colorList[3]])),
        ),
        widget.child
      ],
    ));
  }
}
