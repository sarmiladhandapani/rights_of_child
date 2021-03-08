import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:rights_of_child/HomePage.dart';
import 'package:rights_of_child/login.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaleAnimation();
  }
}

class ScaleAnimation extends StatefulWidget {
  @override
  _ScaleAnimationState createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      value: 0.9,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationController.forward();
    _makeRedirect();
  }

  _makeRedirect() async {
    await FlutterSession().get('isLoggedIn').then(
        (value) => value == null ? isLoggedIn = false : isLoggedIn = value);
    print("Is: " + isLoggedIn.toString());
    await FlutterSession().set('isLoggedIn', isLoggedIn).then((value) async {
      await Future.delayed(Duration(seconds: 1), () {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primaryColor: Color(0xFF1f186f),
                    accentColor: Color(0xFF1f186f),
                  ),
                  home: isLoggedIn == true
                      ? HomePage(
                          action: 'success',
                        )
                      : LoginScreen())),
        );
      });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ScaleTransition(
            scale: animation,
            child: FittedBox(
              child: Image.asset('assets/rc-logo.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
