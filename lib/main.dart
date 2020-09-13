import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyWidget(),
    ),
  );
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with TickerProviderStateMixin {
  AnimationController _controller;
  AudioPlayer tikPlayer;
  AudioPlayer tokPlayer;
  String _label1 = "I";
  String _label2 = "O";
  final Curve _animationCurve = Interval(0.3, 0.7, curve: Curves.easeInOut);
  bool playing = true;

  @override
  void initState() {
    super.initState();
    tikPlayer = AudioPlayer();
    tokPlayer = AudioPlayer();
    tikPlayer.setVolume(50);
    tokPlayer.setVolume(50);
    tikPlayer.setAsset("assets/tik.mp3");
    tokPlayer.setAsset("assets/tok.mp3");

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 1,
      ),
    )
      ..addListener(() {
        setState(() {
          playing = true;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _switchLables(false);
          _controller.forward(from: 0.0);
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    tikPlayer.dispose();
    tokPlayer.dispose();
    super.dispose();
  }

  void _switchLables(bool stop) {
    if (_label1 == "I" || stop) {
      tokPlayer.seek(Duration(milliseconds: 0));
      tokPlayer.play();
      _label1 = "O";
      _label2 = "I";
    } else {
      tikPlayer.seek(Duration(milliseconds: 0));
      tikPlayer.play();
      _label1 = "I";
      _label2 = "O";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (playing) {
          setState(() {
            playing = false;
          });
          tikPlayer.stop();
          tokPlayer.stop();
          _controller.stop();
          _switchLables(true);
        } else {
          _controller.forward();
          setState(() {
            playing = true;
          });
        }
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
            child: Center(
              child: FittedBox(
                child: Container(
                  height: 400,
                  width: 450,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 3),
                            color: Colors.black26,
                            blurRadius: 10)
                      ]),
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          height: 55,
                          width: 450,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "T",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                ),
                              ),
                              ClipRect(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    FractionalTranslation(
                                      translation: Offset(
                                          0,
                                          _animationCurve.transform(
                                                  _controller.value) -
                                              1),
                                      child: Center(
                                        child: Text(
                                          _label2,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 35,
                                          ),
                                        ),
                                      ),
                                    ),
                                    FractionalTranslation(
                                      translation: Offset(
                                          0,
                                          _animationCurve
                                              .transform(_controller.value)),
                                      child: Center(
                                        child: Text(
                                          _label1,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 35,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "C",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                ),
                              ),
                              Text(
                                "K",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
