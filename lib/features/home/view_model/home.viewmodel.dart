import 'package:cheetah_flutter/cheetah_error.dart';
import 'package:dart_openai/openai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpteacher/class/STT.class.dart';
import 'package:gpteacher/class/TTS.class.dart';
import 'package:gpteacher/class/conversations/ConversationManager.class.dart';
import 'package:gpteacher/enums/LanguageLevel.dart';
import 'package:gpteacher/features/get_int_injector.dart';
import 'package:gpteacher/features/home/view_model/home.state.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  late ConversationManager conversationManager;
  //TTS TTS({required HomeBiewModel homeView}})
  late TTS tts;

  // final openAI = OpenAI.instance.build(
  //     token: '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',
  //     baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 30)));
  final ScrollController scrollControllerAgentOutput = ScrollController();
  bool voiceInProcess = false;
  String agentOutputBuff = "";
  String userInfos = "";

  HomeViewModel()
      : super(HomeState(
          selectedLanguageLevel: LanguageLevel.beginner,
          selectedSubject: 'Global',
          ttsEnabled: true,
          isListeningAudio: false,
        )) {
    conversationManager =
        ConversationManager(subjectName: state.selectedSubject);
    locator.registerSingleton<STT>(STT(
        transcriptCallback: voiceTranscriptCallback,
        changeAudioRecordingState: changeAudioRecordingState));
    tts = TTS(homeView: this);
    // askToGPT(
    // "Say (Hello my name is Jack, I'am here to help you to practice your english. What would you like to talk about?)");
  }

  set userInput(String value) {
    state = state.copyWith(userInput: value);
  }

  void setSelectedSubject(String subject) {
    state = state.copyWith(selectedSubject: subject);
    conversationManager =
        ConversationManager(subjectName: state.selectedSubject);
  }

  void setLanguageLevel(String level) {
    state =
        state.copyWith(selectedLanguageLevel: LanguageLevel.fromString(level));
  }

  void changeTTSState(bool value) {
    state = state.copyWith(ttsEnabled: value);
  }

  void changeAudioRecordingState(bool value) {
    state = state.copyWith(isListeningAudio: value);
    if (state.isListeningAudio) {
      startVoiceProcessing();
    } else {
      stopVoiceProcessing();
    }
  }

  void askToGPT2(String userInput) {
    String prevAgOut = state.agentOutput;
    final req = conversationManager.generator(
        userInput: userInput,
        previousAnswer:
            state.agentOutput, //nik sa mere faire une sliding windows.
        level: state.selectedLanguageLevel,
        data: <String, dynamic>{'userinfos': userInfos});

    Stream<OpenAIStreamChatCompletionModel> chatStream = OpenAI.instance.chat
        .createStream(model: "gpt-3.5-turbo", messages: req, maxTokens: 200);

    tts.textInAdding = true;
    state = state.copyWith(agentOutput: "");
    chatStream.listen((chatStreamEvent) {
      print(chatStreamEvent.choices.last.delta.content);
      if (chatStreamEvent.choices.last.delta.content == null) {
        return;
      }
      String newEntry = chatStreamEvent.choices.last.delta.content!;
      state = state.copyWith(agentOutput: state.agentOutput + newEntry);
      agentOutputBuff += newEntry;
      if (newEntry.contains(RegExp(r'[\.|\?|\!|\;]'))) {
        if (state.ttsEnabled) {
          tts.addNewSentenceToQueue(agentOutputBuff);
        }
        agentOutputBuff = "";
      }
    }, onDone: () {
      tts.textInAdding = false;
      print("Réponse final de l'agent");
      print(state.agentOutput);
      locator.get<Mixpanel>().track("gptAnswer",
          properties: {'1-user': userInput, "2-gpt": state.agentOutput});
      state = state.copyWith(userInput: "");
      conversationManager.summarize(userInput, prevAgOut);
    }, onError: (err, st) {
      state = state.copyWith(
          agentOutput:
              "⚠️ sorry, i encountered a technical problem, can you repeat please.");
    });
  }

//==============================================
//===============VOICE PROCESSING===============
//==============================================

  Future<void> startVoiceProcessing() async {
    if (voiceInProcess) {
      return;
    }
    try {
      locator.get<STT>().startProcess();
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
      await locator.get<STT>().stopProcess();
      voiceInProcess = false;
    } on CheetahException catch (ex) {
      print("Failed to start audio capture: ${ex.message}");
    }
  }

  void voiceProcessing(bool value) {
    state = state.copyWith(isListeningAudio: value);
  }

  void voiceTranscriptCallback(String transcript) {
    // bool shouldScroll = scrollControllerAgentOutput.position.pixels ==
    //     scrollControllerAgentOutput.position.maxScrollExtent;
    if (kIsWeb) {
      state = state.copyWith(userInput: transcript);
    } else {
      state = state.copyWith(userInput: state.userInput + transcript);
    }
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (shouldScroll && !scrollControllerAgentOutput.position.atEdge) {
    //     scrollControllerAgentOutput
    //         .jumpTo(scrollControllerAgentOutput.position.maxScrollExtent);
    //   }
    // });
  }
}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  return HomeViewModel();
});
