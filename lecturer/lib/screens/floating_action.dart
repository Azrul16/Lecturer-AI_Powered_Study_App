// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class FloatingMicWidget extends StatefulWidget {
//   @override
//   _FloatingMicWidgetState createState() => _FloatingMicWidgetState();
// }

// class _FloatingMicWidgetState extends State<FloatingMicWidget>
//     with SingleTickerProviderStateMixin {
//   bool isRecording = false;
//   late AnimationController _animationController;
//   FlutterSoundRecorder? _audioRecorder;
//   String? _audioFilePath;

//   @override
//   void initState() {
//     super.initState();
//     _audioRecorder = FlutterSoundRecorder();
//     _initializeRecorder();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 1),
//       lowerBound: 0.8,
//       upperBound: 1.2,
//     )..addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _animationController.reverse();
//       } else if (status == AnimationStatus.dismissed) {
//         _animationController.forward();
//       }
//     });
//   }

//   Future<void> _initializeRecorder() async {
//     final status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       // Show permission request if not granted
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Microphone permission is required")),
//       );
//       return;
//     }
//     await _audioRecorder?.openRecorder(); // Deprecated in the latest version
//   }

//   @override
//   void dispose() {
//     _audioRecorder?.closeRecorder();
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _toggleRecording() async {
//     setState(() {
//       isRecording = !isRecording;
//     });

//     if (isRecording) {
//       // Start recording
//       final directory = await getApplicationDocumentsDirectory();
//       _audioFilePath =
//           '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
//       await _audioRecorder?.startRecorder(
//         toFile: _audioFilePath,
//         codec: Codec.aacADTS,
//       );
//       _animationController.forward();
//     } else {
//       // Stop recording
//       await _audioRecorder?.stopRecorder();
//       _animationController.stop();
//       _animationController.value = 1.0;
//       setState(() {
//         // Recordings are saved at _audioFilePath
//       });
//     }
//   }

//   void _showFloatingWindow(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               elevation: 10,
//               backgroundColor: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.all(30.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     AnimatedBuilder(
//                       animation: _animationController,
//                       builder: (context, child) {
//                         return Transform.scale(
//                           scale: isRecording ? _animationController.value : 1.0,
//                           child: Icon(
//                             Icons.mic,
//                             size: 100,
//                             color: isRecording ? Colors.red : Colors.blue,
//                           ),
//                         );
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       isRecording ? "Recording..." : "Press Start to Record",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               _toggleRecording();
//                             });
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 isRecording ? Colors.red : Colors.green,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 30,
//                               vertical: 15,
//                             ),
//                             textStyle: TextStyle(fontSize: 18),
//                           ),
//                           child: Text(isRecording ? "Stop" : "Start"),
//                         ),
//                         if (!isRecording)
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue,
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 30,
//                                 vertical: 15,
//                               ),
//                               textStyle: TextStyle(fontSize: 18),
//                             ),
//                             child: Text("Cancel"),
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () => _showFloatingWindow(context),
//       backgroundColor: Colors.orange,
//       shape: CircleBorder(),
//       child: Icon(Icons.mic, color: Colors.white, size: 35),
//     );
//   }
// }
