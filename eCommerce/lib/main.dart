import 'dart:async';

import 'package:ecommerce/home_screen.dart';
import 'package:ecommerce/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool loggedStatus = false;

  @override
  void initState() {
    getSharedPrefValues();

    // For animating Logo - zoom in
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animation.addListener(() => this.setState(() {}));
    _animationController.forward();

    super.initState();
  }

  void getSharedPrefValues() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getBool("LOGGED_IN") != null) {
      setState(() {
        loggedStatus = prefs.getBool("LOGGED_IN")!;
        //print('loggedStatus $loggedStatus');
      });
    }

    // Checking user login status - navigate either to login screen or to home screen
    if(loggedStatus){
      Timer(const Duration(seconds: 3), () async {

        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const HomeScreen(title: 'Ecommerce',),
          ),
              (route) => false,//if you want to disable back feature set to false
        );

      });
    } else {
      Timer(const Duration(seconds: 3), () async {

        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const Login(title: 'Login',),
          ),
              (route) => false,//if you want to disable back feature set to false
        );

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text(widget.title),
      ),*/
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /*FlutterLogo(
                      size: _animation.value * 100.0,
                    ),*/
                    Image(
                      image: const AssetImage('assets/images/logo_text_remove_bg.png'),
                      width: _animation.value * 300.0,
                    ),
                  ],
                ),
              ),
            ),
          ])
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
