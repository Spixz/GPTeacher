import 'package:gpteacher/enums/LanguageLevel.dart';

import 'subject.class.dart';

class Global extends Subject {
  Global()
      : super(
          name: "Restaurent",
          summarizeInfos: false,
        );

  @override
  List<Map<String, String>> initMessage(LanguageLevel level) {
    return [
      {
        "role": "system",
        "content":
            "Your name is Jack, you are a real person capable of discussing anything and everything with a person. You need to adapt your pitch to a person learning English with an ${level.toString()} level. You need to ask question to your interlocutor to make him practice his english and don't develop your answers too much unless you are asked to."
      },
      {"role": "user", "content": "(You say hello to your interlocutor)"}
    ];
  }

  @override
  List<Map<String, String>> generateAnswer(String userInput,
      String previousAnswer, LanguageLevel level, Map<String, dynamic>? data) {
    return [
      {
        "role": "system",
        "content":
            "Your name is Jack, you are a real person capable of discussing anything and everything with a person. You need to adapt your pitch to a person learning English with an ${level.toString()} level. You need to ask question to your interlocutor to make him practice his english and don't develop your answers too much unless you are asked to."
      },
      {"role": "assistant", "content": previousAnswer},
      {"role": "user", "content": userInput}
    ];
  }

  @override
  List<Map<String, String>> generateSummarization(
      String userInput, String previousAnswer) {
    return [
      Map.of({
        "role": "user",
        "content":
            """extract only the information that might be important to a restaurant server.
            Write them in this form:\n
            Example: [Mode of payment: credit card, entry: with, main dish: turkey]
            The information must come from only the Client message.
            If there is no information of interest to a restaurant waiter, write "empty".
            
            Serveur: $previousAnswer
            Client: $userInput
            """
      })
    ];
  }
}
