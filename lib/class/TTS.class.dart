import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gpteacher/features/home/view_model/home.viewmodel.dart';

class TTS {
  FlutterTts flutterTts = FlutterTts();
  Queue<String> textToReadQueue = Queue();
  bool isSpeaking = false;
  bool textInAdding = false;
  HomeViewModel homeView;

  TTS({
    required this.homeView,
  }) {
    initTts();
  }

  Future<void> initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(1);

    flutterTts.setCompletionHandler(() {
      textToReadQueue.removeLast();
      isSpeaking = false;

      if (textToReadQueue.isNotEmpty) {
        isSpeaking = true;
        speak(textToReadQueue.last);
      } else if (textInAdding == false && textToReadQueue.isEmpty) {
        homeView.changeAudioRecordingState(true);
      }
    });
    // await flutterTts.setVoice({"name": "en-us-x-sfg#male_1-local"});
    // await flutterTts.setSharedInstance(true);
  }

  void addNewSentenceToQueue(String newSentence) {
    textToReadQueue.addFirst(newSentence);
    if (isSpeaking == false && textToReadQueue.length == 1) {
      isSpeaking = true;
      speak(textToReadQueue.last);
    }
  }

  Future speak(String text) async {
    homeView.changeAudioRecordingState(false);
    flutterTts.speak(text);
  }
}

final ttsProvider = Provider<TTS>((ref) {
  final viewModel = ref.watch(homeViewModelProvider.notifier);
  return TTS(homeView: viewModel);
});
