import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gpteacher/class/STT.class.dart';
import 'package:gpteacher/features/get_int_injector.dart';
import 'package:gpteacher/features/home/view_model/home.state.dart';
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
    await flutterTts.setSpeechRate(0.5);

    flutterTts.setCompletionHandler(() {
      textToReadQueue.removeLast();
      isSpeaking = false;

      if (textToReadQueue.isNotEmpty) {
        isSpeaking = true;
        print("Speak 2 ${textToReadQueue.last}");
        speak(textToReadQueue.last);
      } else if (textInAdding == false && textToReadQueue.isEmpty) {
        print("Il n'y a plus de text à lire");
          homeView.changeAudioRecordingState(true);
      }
    });
    // await flutterTts.setVoice({"name": "en-us-x-sfg#male_1-local"});
    // await flutterTts.setSharedInstance(true);
  }

  void addNewSentenceToQueue(String newSentence) {
    textToReadQueue.addFirst(newSentence);
    print("add: is speking: $isSpeaking, queue: $textToReadQueue");
    if (isSpeaking == false && textToReadQueue.length == 1) {
      isSpeaking = true;
      print("Speak de $newSentence");
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
