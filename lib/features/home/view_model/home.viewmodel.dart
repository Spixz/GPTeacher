import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cheetah_flutter/cheetah_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpteacher/class/STT.class.dart';
import 'package:gpteacher/class/TTS.class.dart';
import 'package:gpteacher/class/conversations/ConversationManager.class.dart';
import 'package:gpteacher/enums/LanguageLevel.dart';
import 'package:gpteacher/features/home/view_model/home.state.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  late ConversationManager conversationManager;
  //TTS TTS({required HomeBiewModel homeView}})
  late TTS tts;
  late STT stt;

  final openAI = OpenAI.instance.build(
      token: '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',
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 30)));
  final ScrollController scrollControllerAgentOutput = ScrollController();
  bool voiceInProcess = false;
  String agentOutputBuff = "";
  String userInfos = "";

  HomeViewModel()
      : super(HomeState(
          selectedLanguageLevel: LanguageLevel.beginner,
          selectedSubject: 'Global',
          ttsEnabled: false,
          isListeningAudio: false,
        )) {
    conversationManager =
        ConversationManager(subjectName: state.selectedSubject);
    stt = STT(homeView: this);
    tts = TTS(homeView: this);
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

  void askToGPT(String userInput) {
    String prevAgOut = state.agentOutput;
    final req = conversationManager.generator(
        userInput: userInput,
        previousAnswer:
            state.agentOutput, //nik sa mere faire une sliding windows.
        level: state.selectedLanguageLevel,
        data: <String, dynamic>{'userinfos': userInfos});
    print("\n\nRequete envoyé à l'agent");
    print(req);
    final request = ChatCompleteText(
        messages:
            // [Map.of({"role": "user", "content": userInput})]
            req,
        maxToken: 200,
        model: ChatModel.gptTurbo);

    tts.textInAdding = true;
    state = state.copyWith(agentOutput: "");
    openAI.onChatCompletionSSE(request: request).listen((it) async {
      if (it.choices.last.message?.content != null) {
        String newEntry = it.choices.last.message!.content;
        state = state.copyWith(agentOutput: state.agentOutput + newEntry);
        print(state.agentOutput);
        agentOutputBuff += newEntry;
        if (newEntry.contains(RegExp(r'[\.|\?|\!|\;]'))) {
          if (state.ttsEnabled) {
            //desactivativation ici
            print("Ajout de la phrase à la queue de lecture");
            tts.addNewSentenceToQueue(agentOutputBuff);
          }
          agentOutputBuff = "";
        }
      }
      // debugPrint(it.choices.last.message?.content);
    }, onDone: () {
      tts.textInAdding = false;
      state = state.copyWith(userInput: "");
      print("Réponse final de l'agent");
      print(state.agentOutput);
      conversationManager.summarize(userInput, prevAgOut);
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
      stt.startProcess();
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
      stt.stopProcess();
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
