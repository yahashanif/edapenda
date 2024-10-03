import 'package:flutter/material.dart';

class ColorChangingProgressIndicator extends StatefulWidget {
  @override
  _ColorChangingProgressIndicatorState createState() =>
      _ColorChangingProgressIndicatorState();
}

class _ColorChangingProgressIndicatorState
    extends State<ColorChangingProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = _controller.drive(
      ColorTween(
        begin: Colors.blue,
        end: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return CircularProgressIndicator(
            valueColor: _colorAnimation,
          );
        },
      ),
    );
  }
}
