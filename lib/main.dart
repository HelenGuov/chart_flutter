import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' show lerpDouble;
import 'dart:ui';
import 'dart:ui' show TextStyle;
import 'dart:typed_data';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Chart",
      home: new ChartPage()
    );
  }
}

class ChartPage extends StatefulWidget {
  @override
  ChartPageState createState() => new ChartPageState();
}

class ChartPageState extends State<ChartPage> with TickerProviderStateMixin {
  final random = new Random();
  int dataSet = 50;
  AnimationController animation;
  double startHeight; // Strike one.
  double currentHeight; // Strike two.
  double endHeight; // Strike three. Refactor.

  @override
  void initState() {
    super.initState();
    animation = new AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          currentHeight = lerpDouble( // Strike one.
            startHeight,
            endHeight,
            animation.value,
          );
        });
      });
    startHeight = 0.0; // Strike two.
    currentHeight = 0.0;
    endHeight = dataSet.toDouble();
    animation.forward();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  void changeData() {
    setState(() {
      startHeight = currentHeight; // Strike three. Refactor.
      dataSet = random.nextInt(100);
      endHeight = dataSet.toDouble();
      animation.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:
         new GestureDetector(
            onTap: () {
              debugPrint("hello");
            },
            child:
                new Container(
                    alignment: FractionalOffset.center,
                    child: new CustomPaint(

                         size: new Size(400.0, 400.0),
                         painter: new BarChartPainter(currentHeight),
        ))),
    );
  }
}

class BarChartPainter extends CustomPainter {
  static const barWidth = 10.0;

  BarChartPainter(this.barHeight);

  final double barHeight;

  double _getRelativeValue(double iData, double maxData, double sizewidth) {
   // double xPadding = 50.0;
   // double yPadding = 30.0;
    //double relValue = iData;

    double relValue = iData / maxData * sizewidth;

   /* if (isX) {
      relValue = iData / maxData * size.width;
      //x-value
      double contentStart = 0 + padding;
      double contentEnd = size.width - padding;

      if (relValue > contentStart) {
        relValue += padding;
      }
      else if (relValue > contentEnd){
        relValue -= padding;
      }
    }
    else {
      //y value
      relValue = iData / maxData * size.height;
      double yContentStart = 0 - padding;
      double yContentEnd = size.height - padding;
    }*/
    return relValue;
  }

  //formula for getting yRelPoint
  double _getYRelPoint(double h, double yi, double ymax) {
    var yiRel = yi / ymax * h;
    var yRel =  h - yiRel;
    return yRel;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //canvas
    final paint = new Paint()
      ..color = Colors.blue[400]
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
       ..style = PaintingStyle.fill;


/*
    canvas.drawRect(new Rect.fromLTWH(0.0, 20.0, 30.0, 80.0), paint);
*/

/*
    canvas.drawRect(new Rect.fromPoints(new Offset(0.0, 20.0), new Offset(5.0, 20.0)), paint);
*/
   /* var pointListof = [new Offset(51.0, -50.0), new Offset(100.0, -100.0), new Offset(100.0, -100.0), new Offset(150.0, -50.0),
            new Offset(150.0, -50.0), new Offset(200.0, -100.0)];*/

    /*double xmax = -100.0;
    var pointList = new Float32List.fromList(
        [  _getRelativeValue(50.0, xmax, size.width), _getRelativeValue(-50.0, xmax, size.width),
          50.0, -50.0,
        100.0, -100.0,
        100.0, -100.0,
        150.0, -50.0,
        150.0, -50.0,
        200.0, -100.0]);*/

    double xmax = 200.0;
    double ymax = 100.0;
    var pointList = new Float32List.fromList(
        [_getRelativeValue(50.0, xmax, size.width), _getYRelPoint(size.height, 50.0, 100.0),
        _getRelativeValue(100.0, xmax, size.width), _getYRelPoint(size.height, 100.0, 100.0),
        _getRelativeValue(100.0, xmax, size.width), _getYRelPoint(size.height, 100.0, 100.0),
        _getRelativeValue(150.0, xmax, size.width), _getYRelPoint(size.height, 50.0, 100.0),
        _getRelativeValue(150.0, xmax, size.width), _getYRelPoint(size.height, 50.0, 100.0),
        _getRelativeValue(200.0, xmax, size.width), _getYRelPoint(size.height, 100.0, 100.0)
        ]);
    canvas.drawRawPoints(PointMode.lines,  pointList, paint);

    final paint2 = new Paint()
      ..color = Colors.red[400]
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    var pointList2 = new Float32List.fromList(
        [70.0, -50.0,
        170.0, -100.0,
        170.0, -100.0,
        250.0, -50.0,
        250.0, -50.0,
        300.0, -100.0]);

    final paintAx = new Paint()
      ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    //canvas.drawRawPoints(PointMode.lines, pointList2, paintAx);

    //draw axes
    //x axis
    var xaxispoints = new Float32List.fromList(
      [ 0.0, 50.0, 500.0, 50.0]
    );

    canvas.drawRawPoints(PointMode.lines, xaxispoints, paintAx);
    //canvas.drawLine(new Offset(0.0, 0.0), new Offset(500.0, 0.0), paintAx);

    //y axis
    //canvas.drawLine(new Offset(0.0, 0.0), new Offset(0.0, -500.0), paintAx);

    //scales on x-axis
    double xLen = 10.0;
    var pointAxis = new Float32List.fromList([
      0.0, -50.0,
      xLen, -50.0,
      0.0, -100.0,
      xLen, -100.01
    ]);
    canvas.drawRawPoints(PointMode.lines, pointAxis, paintAx);

    //draw text
    var tp = new TextPainter(
        text: new TextSpan(
          text: "100",
          style: new TextStyle(color: Colors.black, fontSize: 15.0)
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
    );
    tp.layout();
    tp.paint(canvas, new Offset(-40.0, -55.0));

    var tp2 = new TextPainter(
      text: new TextSpan(
        text: "1st foot",
        style: new TextStyle(color: Colors.black, fontSize: 20.0)
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left
    );
    tp2.layout();
    tp2.paint(canvas, new Offset(-150.0, -0.0));



    //
    /*canvas.drawCircle(new Offset(2.0, 5.0), 10.0, paint);
    canvas.drawCircle(new Offset(50.0, 100.0), 10.0, paint);
    canvas.drawLine(new Offset(2.0, 5.0), new Offset(50.0, 100.0), paint);
*/
  }


  @override
  bool shouldRepaint(BarChartPainter old) => barHeight != old.barHeight;
}