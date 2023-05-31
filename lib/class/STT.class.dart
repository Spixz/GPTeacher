import 'dart:io';

import 'package:cheetah_flutter/cheetah_error.dart';
import 'package:flutter/foundation.dart';
import 'package:gpteacher/cheetah_manager.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class STT {
  final String accessKey =
      'iucMFDyWvdaKiUzqtipwoQ4jiNSweUIzlUAAxhua49hi/iZHUd+Axw=='; // AccessKey obtained from Picovoice Console (https://console.picovoice.ai/)
  late CheetahManager
      _cheetahManager; //utiliser une facotry qui permettre de l'init ici avec des callbacks
  SpeechToText speechToText = SpeechToText();
  Function(String) transcriptCallback;
  late String processor;

  STT(
      {required this.transcriptCallback,
      required void Function(bool) changeAudioRecordingState}) {
    processor = (kIsWeb) ? "native" : "chetah";
    if (processor == "chetah") {
      initCheetah(transcriptCallback);
    } else {
      speechToText.initialize(
        finalTimeout: const Duration(seconds: 30),
        onStatus: (status) {
          if (status == "notListening") {
            print("Fin de transcription");
            // changeAudioRecordingState(true);
          }
        },
      );
    }
  }

  Future<void> initCheetah(Function(String) transcriptCallback) async {
    String platform = Platform.isAndroid
        ? "android"
        : Platform.isIOS
            ? "ios"
            : throw CheetahRuntimeException(
                "This demo supports iOS and Android only.");
    String modelPath = "assets/models/$platform/cheetah_params.pv";

    try {
      _cheetahManager = await CheetahManager.create(
          accessKey, modelPath, transcriptCallback, errorCallback);
    } on CheetahInvalidArgumentException catch (ex) {
      errorCallback(CheetahInvalidArgumentException(
          "${ex.message}\nEnsure your accessKey '$accessKey' is a valid access key."));
    } on CheetahActivationException {
      errorCallback(CheetahActivationException("AccessKey activation error."));
    } on CheetahActivationLimitException {
      errorCallback(CheetahActivationLimitException(
          "AccessKey reached its device limit."));
    } on CheetahActivationRefusedException {
      errorCallback(CheetahActivationRefusedException("AccessKey refused."));
    } on CheetahActivationThrottledException {
      errorCallback(
          CheetahActivationThrottledException("AccessKey has been throttled."));
    } on CheetahException catch (ex) {
      errorCallback(ex);
    }
  }

  Future<void> startProcess() async {
    if (processor == "chetah") {
      await _cheetahManager.startProcess();
    } else {
      await speechToText.listen(
          localeId: "en_US",
          onResult: (SpeechRecognitionResult result) {
            List<String> res = [];
            for (var element in result.alternates) {
              res.add(element.recognizedWords);
            }
            transcriptCallback(res.join(" "));
          });
    }
  }

  Future<void> stopProcess() async {
    if (processor == "chetah") {
      await _cheetahManager.stopProcess();
    } else {
      await speechToText.stop();
    }
  }

  void errorCallback(CheetahException error) {
    print(error);
  }
}
