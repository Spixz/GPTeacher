import 'dart:io';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cheetah_flutter/cheetah_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpteacher/cheetah_manager.dart';
import 'package:gpteacher/enums/LanguageLevel.dart';
import 'package:gpteacher/features/home/view_model/home.state.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  late CheetahManager _cheetahManager;
  final String accessKey =
      'iucMFDyWvdaKiUzqtipwoQ4jiNSweUIzlUAAxhua49hi/iZHUd+Axw=='; // AccessKey obtained from Picovoice Console (https://console.picovoice.ai/)
  final openAI = OpenAI.instance.build(
      token: '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',
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)));
  final ScrollController scrollControllerAgentOutput = ScrollController();
  bool voiceInProcess = false;

  HomeViewModel()
      : super(HomeState(
          selectedLanguageLevel: LanguageLevel.beginner,
          selectedSubject: 'At restaurant',
          ttsEnabled: false,
          isListeningAudio: false,
        )) {
    initCheetah();
  }

  void setSelectedSubject(String subject) {
    state = state.copyWith(selectedSubject: subject);
  }

  void changeAudioRecordingState(bool value) {
    state = state.copyWith(isListeningAudio: value);
    if (state.isListeningAudio) {
      startVoiceProcessing();
    } else {
      stopVoiceProcessing();
    }
  }

  void changeTTSState(bool value) {
    state = state.copyWith(ttsEnabled: value);
    //TODO: if (true) => enable TTS
    //TODO: if (false) => disable TTS
  }

  void setLanguageLevel(String level) {
    state =
        state.copyWith(selectedLanguageLevel: LanguageLevel.fromString(level));
  }

  Future<void> initCheetah() async {
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

  void transcriptCallback(String transcript) {
    bool shouldScroll = scrollControllerAgentOutput.position.pixels ==
        scrollControllerAgentOutput.position.maxScrollExtent;
    state = state.copyWith(userInput: state.userInput + transcript);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (shouldScroll && !scrollControllerAgentOutput.position.atEdge) {
        scrollControllerAgentOutput
            .jumpTo(scrollControllerAgentOutput.position.maxScrollExtent);
      }
    });
  }

  void errorCallback(CheetahException error) {
    print("Erreur lors de l'init de cheetah: ${error.message}");
    // setState(() {
    //   isError = true;
    //   errorMessage = error.message!;
    // });
  }

  Future<void> startVoiceProcessing() async {
    if (voiceInProcess) {
      return;
    }
    try {
      await _cheetahManager.startProcess();
      state = state.copyWith(userInput: "");
      voiceInProcess = true;
    } on CheetahException catch (ex) {
      print("Failed to start audio capture: ${ex.message}");
    }
  }

  Future<void> stopVoiceProcessing() async {
    if (!voiceInProcess) {
      return;
    }
    try {
      await _cheetahManager.stopProcess();
      voiceInProcess = false;
    } on CheetahException catch (ex) {
      print("Failed to start audio capture: ${ex.message}");
    }
  }

  // Future _speak(String text) async {
  //   _stopProcessing();
  //   flutterTts.speak(text);
  // }
}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  return HomeViewModel();
});
