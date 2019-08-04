import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Text Shimmer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            double value = _animation.value;
            Gradient gradient = LinearGradient(
              colors: [Colors.grey, Colors.white, Colors.grey],
              stops: [value - 0.2, value, value + 0.2],
            );
            Shader shader = gradient
                .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
            return Text(
              '文字闪烁效果',
              style: TextStyle(
                fontSize: 28.0,
                foreground: Paint()..shader = shader,
              ),
            );
          },
        ),
      ),
    );
  }
}