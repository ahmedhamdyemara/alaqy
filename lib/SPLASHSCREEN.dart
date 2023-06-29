import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hightx = size.height;
    return Scaffold(
        body: Stack(clipBehavior: Clip.none, children: [
      Center(
          child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset(
                'assets/alaqyx.jpeg',
                fit: BoxFit.contain,
              ))),
      Center(
          child: Column(children: [
        SizedBox(
          height: hightx - 200,
        ),
        LinearProgressIndicator(
          color: Colors.white,
          backgroundColor: Colors.white12,
        ),
      ])),
    ]));
  }
}
