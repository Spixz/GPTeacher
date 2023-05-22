import 'dart:collection';

import 'package:flutter_tts/flutter_tts.dart';

class TTS {
  FlutterTts flutterTts = FlutterTts();
  Queue<String> textToReadQueue = Queue();
  bool isSpeaking = false;
  bool textInAdding = false;

  TTS() {
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
        speak(textToReadQueue.last);
      } else if (textInAdding == false && textToReadQueue.isEmpty) {
        print("Il n'y a plus de text à lire");
        //TODO: _startProcessing(); //GetIT ou dans la même classe
      }
    });
    // await flutterTts.setVoice({"name": "en-us-x-sfg#male_1-local"});
    // await flutterTts.setSharedInstance(true);
  }

  void addNewSentenceToQueue(String newSentence) {
    textToReadQueue.addFirst(newSentence);
    if (isSpeaking != true && textToReadQueue.length == 1) {
      isSpeaking = true;
      print("Speak de $newSentence");
      speak(textToReadQueue.last);
    }
  }

  Future speak(String text) async {
    // _stopProcessing(); TODO: Chetah get it
    flutterTts.speak(text);
  }
}
