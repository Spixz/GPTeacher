import 'package:gpteacher/class/conversations/subjects/global.subject.class.dart';
import 'package:gpteacher/enums/LanguageLevel.dart';

import 'restaurent.subject.class.dart';

abstract class Subject {
  String name;
  bool summarizeInfos;
  Subject({required this.name, required this.summarizeInfos});

  List<Map<String, String>> initMessage(LanguageLevel level);
  List<Map<String, String>> generateAnswer(String userInput,
      String previousAnswer, LanguageLevel level, Map<String, dynamic>? data);
  List<Map<String, String>> generateSummarization(
      String userInput, String previousAnswer);
}

final Map<String, Subject> AllSubjects = {
  'At restaurant': Restaurent(),
  'Global': Global()
};
