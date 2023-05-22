import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:gpteacher/enums/LanguageLevel.dart';

import 'subjects/subject.class.dart';

class ConversationManager {
  int nbInteractions = -1;
  late Subject subject;
  String summarizedData = "";
  final openAI = OpenAI.instance.build(
      token: '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',
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 30)));

  ConversationManager({required String subjectName}) {
    if (!AllSubjects.containsKey(subjectName)) {
      throw Exception("This subject didn't exist");
    }
    subject = AllSubjects[subjectName]!;
  }

  bool get summarizationEnabled => subject.summarizeInfos;

  List<Map<String, String>> generator(
      {required String userInput,
      required String previousAnswer,
      required LanguageLevel level,
      Map<String, dynamic>? data}) {
    nbInteractions += 1;
    if (nbInteractions == 0) {
      return subject.initMessage(level);
    } else {
      if (summarizationEnabled) {
        if (data == null) {
          data = <String, dynamic>{'summarize': summarizedData};
        } else {
          data['summarize'] = summarizedData;
        }
      }
      return subject.generateAnswer(userInput, previousAnswer, level, data);
    }
  }

  void summarize(String userInput, String agPrevOut) {
    if (nbInteractions <= 1 || summarizationEnabled == false) {
      return;
    }
    print("ICI bordel");
    print(nbInteractions);
    print(summarizationEnabled);
    var req = subject.generateSummarization(userInput, agPrevOut);
    final request = ChatCompleteText(
        messages: req, maxToken: 200, model: ChatModel.gptTurbo);

    String anwser = "";
    openAI.onChatCompletionSSE(request: request).listen((it) async {
      if (it.choices.last.message?.content != null) {
        anwser += it.choices.last.message!.content;
      }
    }, onDone: () {
      print("\n==================\nInfos importantes");
      print(req);
      print(anwser);
      if (!anwser.contains("empty")) {
        summarizedData += " $anwser";
      }
      print("======================");
    });
  }
}
