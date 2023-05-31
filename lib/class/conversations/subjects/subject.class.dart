import 'package:dart_openai/openai.dart';
import 'package:gpteacher/class/conversations/subjects/global.subject.class.dart';
import 'package:gpteacher/enums/LanguageLevel.dart';

import 'restaurent.subject.class.dart';

abstract class Subject {
  String name;
  bool summarizeInfos;
  Subject({required this.name, required this.summarizeInfos});

  List<OpenAIChatCompletionChoiceMessageModel> initMessage(LanguageLevel level);
  List<OpenAIChatCompletionChoiceMessageModel> generateAnswer(String userInput,
      String previousAnswer, LanguageLevel level, Map<String, dynamic>? data);
  List<OpenAIChatCompletionChoiceMessageModel> generateSummarization(
      String userInput, String previousAnswer);
}

final Map<String, Subject> AllSubjects = {
  'At restaurant': Restaurent(),
  'Global': Global()
};
