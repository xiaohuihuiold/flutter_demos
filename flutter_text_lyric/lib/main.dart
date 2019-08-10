import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Text Lyric',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static const int LINES = 200;

  final List<int> _rands =
      List.generate(LINES, (index) => (Random().nextInt(3) + 1));

  int _currentIndex = 0;
  double _progress = 0.0;
  Timer _timer;
  bool _horizontal = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        _progress += 0.05;
        if (_progress >= 1.0) {
          _progress = 0;
          _currentIndex++;
          if (_currentIndex >= 200) {
            _currentIndex = 0;
          }
          double inside = _scrollController.position.extentInside;
          double after = _scrollController.position.extentAfter;
          double item = after / LINES;
          _scrollController.animateTo(50.0 * (_currentIndex + 1) - inside / 2,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(_horizontal ? Icons.arrow_upward : Icons.arrow_forward),
        onPressed: () {
          setState(() {
            _horizontal = !_horizontal;
          });
        },
      ),
      body: ListView.builder(
        scrollDirection: _horizontal ? Axis.horizontal : Axis.vertical,
        controller: _scrollController,
        itemCount: LINES,
        physics: BouncingScrollPhysics(),
        itemBuilder: (buildContext, index) {
          return Container(
            alignment: Alignment.center,
            width: _horizontal ? 50.0 : null,
            height: _horizontal ? null : 50.0,
            child: LyricText(
              horizontal: _horizontal,
              progress: () {
                if (index < _currentIndex) {
                  return 1.0;
                } else if (index > _currentIndex) {
                  return 0.0;
                }
                return _progress;
              }(),
              child: Text(
                (_horizontal ? '测\n试\n歌\n词\n' : '测试歌词') * _rands[index],
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                  shadows: [BoxShadow(color: Colors.black, blurRadius: 2.0)],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LyricText extends SingleChildRenderObjectWidget {
  final double progress;
  final Widget child;
  final bool horizontal;

  LyricText({this.horizontal, this.progress = 0.0, this.child})
      : assert(progress >= 0.0 && progress <= 1.0 && horizontal != null);

  @override
  RenderObject createRenderObject(BuildContext context) =>
      LyricTextRenderBox(this.progress, this.horizontal);

  @override
  void updateRenderObject(
      BuildContext context, LyricTextRenderBox lyricTextRenderBox) {
    lyricTextRenderBox.progress = this.progress;
    lyricTextRenderBox.horizontal = this.horizontal;
  }
}

class LyricTextRenderBox extends RenderProxyBox {
  double _progress;

  set progress(v) {
    _progress = v;
    markNeedsPaint();
  }

  bool _horizontal;

  set horizontal(v) {
    _horizontal = v;
    markNeedsPaint();
  }

  Paint _tempPaint = Paint();
  Paint _lyricPaint = Paint()
    ..blendMode = BlendMode.srcIn
    ..color = Colors.blue;

  LyricTextRenderBox(this._progress, this._horizontal);

  @override
  bool get alwaysNeedsCompositing => child != null;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    Canvas canvas = context.canvas;
    canvas.saveLayer(offset & child.size, _tempPaint);
    context.paintChild(child, offset);
    canvas.drawRect(
        offset &
            Size(child.size.width * (_horizontal ? 1.0 : _progress),
                child.size.height * (_horizontal ? _progress : 1.0)),
        _lyricPaint);
    canvas.restore();
  }
}
