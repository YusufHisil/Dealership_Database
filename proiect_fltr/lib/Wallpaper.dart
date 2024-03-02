import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key, required this.stackChildren});
  final List<Widget> stackChildren;

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List<String> images = [
    'assets/brabus.jpg',
    'assets/cayenne.jpg',
    'assets/s60.jpg',
    'assets/911.jpg',
    'assets/amg.jpg',
    'assets/audi4.jpg',
    'assets/xc60.jpg'
  ];

  var rng = Random();
  int currentImage = 0;
  late Timer imageTimer;
  late Timer fadeTimer;
  bool _isVisible = true;
  int ctr = 0;


  @override
  void initState() {
    super.initState();
    // Start the periodic function when the widget is created
    startImageFunction();
    startFadeTimer();
    currentImage = rng.nextInt(images.length);
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to prevent memory leaks
    imageTimer.cancel();
    fadeTimer.cancel();
    super.dispose();
  }

  void startImageFunction() {
    const duration = Duration(milliseconds: 4000);
    imageTimer = Timer.periodic(duration, (Timer t) {
      // Replace this with the function you want to run periodically
      setState(() {
        currentImage++;
        currentImage %= images.length;
      });
    });
  }

  void startFadeTimer()
  {
    fadeTimer = Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      if (ctr == 6) {
        setState(() {
          _isVisible = !_isVisible;
        });
        ctr++;
      } else if (ctr == 7) {
        setState(() {
          _isVisible = !_isVisible;
        });
        ctr = 0;
      } else {
        ctr++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = widget.stackChildren;
    return Stack(fit: StackFit.expand, children: <Widget>[
      AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _isVisible ? 1.0 : 0.2,
      child: Image.asset(images[currentImage], fit: BoxFit.fill),

      )]+
      stackChildren);
  }
}
