import 'package:dart_openai/openai.dart';
import 'package:gpteacher/enums/LanguageLevel.dart';

import 'subject.class.dart';

class Restaurent extends Subject {
  Restaurent()
      : super(
          name: "Restaurent",
          summarizeInfos: true,
        );

  @override
   List<OpenAIChatCompletionChoiceMessageModel> initMessage(LanguageLevel level) {
    return const [
       OpenAIChatCompletionChoiceMessageModel(role: OpenAIChatMessageRole.system, content: "You are a waiter in a restaurant who serves a customer and accompanies him during all stages of his meal." // At the end of your answer, write down the most important information given by the customer to remember for a waiter in this form: customers: x, main dish: y, drink: r. The customer enters the establishment, greet him with a sentence. "
        // "Tu est un serveur de restaurant qui sert un clients et l'accompagne à toutes les étapes de son repas. A la fin de t'as réponse, écris les infos les plus importantes donnée par le client à retenir pour un serveur sous cette forme: clients: x, plat princiapl: y, boisson: r. Le client entre dans l'établissement, acceuille le par une phrase. "
      ),
       OpenAIChatCompletionChoiceMessageModel(role: OpenAIChatMessageRole.user, content: 
            "(The customer enters the establishment, greeting him with a sentence.)"
      )
    ];
  }

  @override
   List<OpenAIChatCompletionChoiceMessageModel> generateAnswer(String userInput,
      String previousAnswer, LanguageLevel level, Map<String, dynamic>? data) {
    return [
      const OpenAIChatCompletionChoiceMessageModel(role: OpenAIChatMessageRole.system, content: 
            // "You are a waiter in a restaurant who serves a customer and accompanies him during all stages of his meal."//At the end of each of your answers you MUST write the most important information given by the customer in this form: [customer: x, main dish: y, drink: r]"
            "Tu est un serveur de restaurant qui sert un clients et l'accompagne à toutes les étapes de son repas." // A la fin de chacune de t'es réponse écris OBLIGATOIREMENT sous cette forme: clients: x, plat princiapl: y, boisson: r, écris les infos les plus importantes donnée par le client. Ne génère que les réponses du Serveur."
      ),
      OpenAIChatCompletionChoiceMessageModel(role: OpenAIChatMessageRole.assistant, content: previousAnswer),
      if (data != null &&
          data.containsKey('summarize') &&
          data['summarize'].toString().isNotEmpty)
        OpenAIChatCompletionChoiceMessageModel(role: OpenAIChatMessageRole.assistant, content:  "Informations about client : ${data['summarize']}"
        ),

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
