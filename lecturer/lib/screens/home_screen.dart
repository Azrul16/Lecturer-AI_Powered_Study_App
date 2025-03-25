import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> recordings = [];
  FlutterSoundPlayer? _audioPlayer;
  FlutterSoundRecorder? _audioRecorder;
  String? _currentlyPlaying;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadRecordings();
    _audioPlayer = FlutterSoundPlayer();
    _audioRecorder = FlutterSoundRecorder();
  }

  // Load recordings from the local directory
  Future<void> _loadRecordings() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = Directory(directory.path);
    final files = await dir.list().toList();

    setState(() {
      recordings =
          files
              .where((file) => file.path.endsWith(".aac"))
              .map((file) => file.path)
              .toList();
    });
  }

  // Start recording
  Future<void> _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _audioRecorder?.startRecorder(toFile: filePath);
    setState(() {
      recordings.add(filePath); // Add the new recording immediately
    });
  }

  // Stop recording
  Future<void> _stopRecording() async {
    await _audioRecorder?.stopRecorder();
    _loadRecordings(); // Refresh the recordings list after stopping
  }

  // Play the selected recording
  void _playRecording(String path) async {
    if (_currentlyPlaying != null && _currentlyPlaying != path) {
      await _audioPlayer?.stopPlayer();
      setState(() {
        _isPlaying = false;
      });
    }

    if (_currentlyPlaying == path) {
      await _audioPlayer?.stopPlayer();
      setState(() {
        _isPlaying = false;
      });
    } else {
      setState(() {
        _currentlyPlaying = path;
        _isPlaying = true;
      });
      await _audioPlayer?.openPlayer();
      await _audioPlayer?.startPlayer(fromURI: path);
    }
  }

  // Pause the audio
  void _pauseRecording() async {
    await _audioPlayer?.stopPlayer();
    setState(() {
      _isPlaying = false;
    });
  }

  // Delete the recording
  void _deleteRecording(String path) async {
    final file = File(path);
    await file.delete();
    setState(() {
      recordings.remove(path);
    });
  }

  @override
  void dispose() {
    _audioPlayer?.closePlayer();
    _audioRecorder?.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Recordings"),
        actions: [
          IconButton(icon: const Icon(Icons.stop), onPressed: _stopRecording),
          IconButton(icon: const Icon(Icons.mic), onPressed: _startRecording),
        ],
      ),
      body: SafeArea(
        child: Center(
          child:
              recordings.isEmpty
                  ? const Text("No recordings available.")
                  : ListView.builder(
                    itemCount: recordings.length,
                    itemBuilder: (context, index) {
                      final recording = recordings[index];
                      bool isCurrentRecording = _currentlyPlaying == recording;
                      return ListTile(
                        title: Text("Recording ${index + 1}"),
                        subtitle: Text(recording),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                isCurrentRecording && _isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color:
                                    isCurrentRecording && _isPlaying
                                        ? Colors.red
                                        : Colors.green,
                              ),
                              onPressed: () {
                                if (isCurrentRecording && _isPlaying) {
                                  _pauseRecording();
                                } else {
                                  _playRecording(recording);
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteRecording(recording),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
