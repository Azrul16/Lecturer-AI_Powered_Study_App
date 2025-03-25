import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class FloatingMicWidget extends StatefulWidget {
  const FloatingMicWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FloatingMicWidgetState createState() => _FloatingMicWidgetState();
}

class _FloatingMicWidgetState extends State<FloatingMicWidget>
    with SingleTickerProviderStateMixin {
  bool isListening = false;
  late AnimationController _animationController;
  stt.SpeechToText _speech = stt.SpeechToText();
  String recognizedText = "Press Start to Speak";

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      lowerBound: 0.8,
      upperBound: 1.2,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
  }

  Future<void> _initializeSpeech() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Microphone permission is required")),
      );
      return;
    }
    bool available = await _speech.initialize();
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Speech recognition is not available")),
      );
    }
  }

  void _toggleListening() async {
    if (!isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          isListening = true;
          recognizedText = "Listening...";
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              recognizedText = result.recognizedWords;
            });
          },
        );
        _animationController.forward();
      }
    } else {
      _speech.stop();
      setState(() {
        isListening = false;
      });
      _animationController.stop();
      _animationController.value = 1.0;
    }
  }

  void _showFloatingWindow(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: isListening ? _animationController.value : 1.0,
                          child: Icon(
                            Icons.mic,
                            size: 100,
                            color: isListening ? Colors.red : Colors.blue,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      recognizedText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _toggleListening();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isListening ? Colors.red : Colors.green,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Text(isListening ? "Stop" : "Start"),
                        ),
                        if (!isListening)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              textStyle: TextStyle(fontSize: 18),
                            ),
                            child: Text("Close"),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _speech.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showFloatingWindow(context),
      backgroundColor: Colors.orange,
      shape: CircleBorder(),
      child: Icon(Icons.mic, color: Colors.white, size: 35),
    );
  }
}
