// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestGPTView extends ConsumerStatefulWidget {
  const TestGPTView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestGPTViewState();
}

class _TestGPTViewState extends ConsumerState<TestGPTView> {
  String gptOutput = "";


  void askToGPT3() {
    Stream<OpenAIStreamChatCompletionModel> chatStream =
        OpenAI.instance.chat.createStream(
      model: "gpt-3.5-turbo",
      messages: [
        const OpenAIChatCompletionChoiceMessageModel(
          content: "What is mastodon",
          role: OpenAIChatMessageRole.user,
        )
      ],
    );

    chatStream.listen((chatStreamEvent) {
      print(chatStreamEvent);
      print(chatStreamEvent.choices.last.delta.content);
      setState(() {
        gptOutput =
            gptOutput + (chatStreamEvent.choices.last.delta.content ?? "");
      }); // ...
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      gptOutput = "Hello";
    });
    OpenAI.apiKey = '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';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: () {
              askToGPT3();
            },
            child: const Text("Ask to GPT2")),
        Text(gptOutput),
      ],
    );
  }
}
