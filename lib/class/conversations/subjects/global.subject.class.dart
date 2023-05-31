import 'package:dart_openai/openai.dart';
import 'package:gpteacher/enums/LanguageLevel.dart';

import 'subject.class.dart';

String mainSubject(LanguageLevel level) =>
    "Your name is Jack, you're not an artificial intelligence but you are a friendly real person capable of discussing anything and everything with a person. You need to adapt the word you used to a person learning English with an ${level.toString()} level. You are curious and love to talk about differents subjects.";

class Global extends Subject {
  Global()
      : super(
          name: "Restaurent",
          summarizeInfos: false,
        );

  @override
  List<OpenAIChatCompletionChoiceMessageModel> initMessage(LanguageLevel level) {
    return [
      OpenAIChatCompletionChoiceMessageModel(content:  mainSubject(level), role: OpenAIChatMessageRole.system),
      // {"role": "user", "content": "(Present yourself)"}
    ];
  }

  @override
  List<OpenAIChatCompletionChoiceMessageModel> generateAnswer(String userInput,
      String previousAnswer, LanguageLevel level, Map<String, dynamic>? data) {
    return [
      OpenAIChatCompletionChoiceMessageModel(role: OpenAIChatMessageRole.system, content: mainSubject(level)),
      OpenAIChatCompletionChoiceMessageModel(role: OpenAIChatMessageRole.assistant, content: "My name is Jack, I'am not an artificial intelligence but I'am a friendly real person capable of discussing anything and everything with a person. I need to adapt the word I used to a person learning English with an ${level.toString()} level. I'am curious and love to talk about differents subjects. I can talk about myself and give my opinion. I'am talking more frequently about the every day life."),
      OpenAIChatCompletionChoiceMessageModel(role: OpenAIChatMessageRole.assistant, content: previousAnswer),
      OpenAIChatCompletionChoiceMessageModel(role: OpenAIChatMessageRole.user, content: userInput)
    ];
  }

  @override
  List<OpenAIChatCompletionChoiceMessageModel> generateSummarization(
      String userInput, String previousAnswer) {
    return [
      OpenAIChatCompletionChoiceMessageModel(role: OpenAIChatMessageRole.user, content:
            """extract only the information that might be important to a restaurant server.
            Write them in this form:\n
            Example: [Mode of payment: credit card, entry: with, main dish: turkey]
            The information must come from only the Client message.
            If there is no information of interest to a restaurant waiter, write "empty".
            
            Serveur: $previousAnswer
            Client: $userInput
            """
      )
    ];
  }
}
