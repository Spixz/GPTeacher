import 'package:dart_openai/openai.dart';
import 'package:gpteacher/enums/LanguageLevel.dart';

import 'subjects/subject.class.dart';

class ConversationManager {
  int nbInteractions = -1;
  late Subject subject;
  String summarizedData = "";

  ConversationManager({required String subjectName}) {
    if (!AllSubjects.containsKey(subjectName)) {
      throw Exception("This subject didn't exist");
    }
    subject = AllSubjects[subjectName]!;
  }

  bool get summarizationEnabled => subject.summarizeInfos;

  List<OpenAIChatCompletionChoiceMessageModel> generator(
      {required String userInput,
      required String previousAnswer,
      required LanguageLevel level,
      Map<String, dynamic>? data}) {
    nbInteractions += 1;
    if (nbInteractions == -1 /*0*/) {
      return subject.initMessage(level);
    } else {
      if (summarizationEnabled) {
        if (data == null) {
          data = <String, dynamic>{'summarize': summarizedData};
        } else {
          data['summarize'] = summarizedData;
        }
      }
      //TODO: Mettre le convertisseur ici
      return subject.generateAnswer(userInput, previousAnswer, level, data);
    }
  }

  void summarize(String userInput, String agPrevOut) {
  //! Utilise l'ancienne librairie chat_gpt_sdk d'on le stream ne fonctionne pas

    if (nbInteractions <= 1 || summarizationEnabled == false) {
      return;
    }

    //var req = subject.generateSummarization(userInput, agPrevOut);
    // final request = ChatCompleteText(
    //     messages: req, maxToken: 200, model: ChatModel.gptTurbo);

    // String anwser = "";
    // openAI.onChatCompletionSSE(request: request).listen((it) async {
    //   if (it.choices.last.message?.content != null) {
    //     anwser += it.choices.last.message!.content;
    //   }
    // }, onDone: () {
    //   print("\n==================\nInfos importantes");
    //   print(req);
    //   print(anwser);
    //   if (!anwser.contains("empty")) {
    //     summarizedData += " $anwser";
    //   }
    //   print("======================");
    // });
  }
}
