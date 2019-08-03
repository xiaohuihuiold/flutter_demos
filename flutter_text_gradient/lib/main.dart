import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Text Gradient',
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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Gradient gradient =
        LinearGradient(colors: [Colors.blueAccent, Colors.greenAccent]);
    Shader shader =
        gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    return Scaffold(
      body: Center(
        child: Text(
          '文字渐变效果',
          style: TextStyle(
            fontSize: 28.0,
            foreground: Paint()..shader = shader,
          ),
        ),
      ),
    );
  }
}
