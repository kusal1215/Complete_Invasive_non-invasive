import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcheckup/components/camera_scan_animation.dart';

class ScanAnimation extends StatefulWidget {
  final CameraController controller;
  const ScanAnimation({Key key, this.controller}) : super(key: key);

  @override
  _ScanAnimationState createState() => _ScanAnimationState();
}

class _ScanAnimationState extends State<ScanAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool _animationStopped = false;
  String scanText = "Scan";
  bool scanning = false;

  @override
  void initState() {
    _animationController = new AnimationController(duration: new Duration(seconds: 1), vsync: this);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });
    startAnimation();
    super.initState();
  }

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.forward(from: 0.0);
    }
  }
  void startAnimation(){
    animateScanAnimation(false);
    _animationStopped = false;
    scanning = true;
    setState(() {

    });

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CameraPreview(widget.controller),
                  ),
                  ImageScannerAnimation(
                    _animationStopped,
                    334,
                    animation: _animationController,
                  )
                ]),
              ])),
    );
  }
}
