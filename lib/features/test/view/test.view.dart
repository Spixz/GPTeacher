// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'dart:ui';

import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestGPTView extends ConsumerStatefulWidget {
  const TestGPTView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestGPTViewState();
}

const testString =
    "Notion is a freemium productivity and note-taking web application developed by Notion Labs Inc. It offers organizational tools including task management, project tracking, to-do lists, bookmarking, and more. Additional offline features are offered by desktop and mobile applications available for Windows, macOS, Android, and iOS. Users can create custom templates, embed videos and web content, and collaborate with others in real-time.";

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
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: const Color(0xFF3C4B60),
        body: SafeArea(
          child: SizedBox(
            height: size.height,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      color: Colors.blue,
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                        child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.5),
                                ],
                              ),
                            ),
                            child: const Text(
                              testString,
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                  ],
                ),
                // TextButton(
                //     onPressed: () {
                //       askToGPT3();
                //     },
                //     child: const Text("Ask to GPT2")),
                // Text(gptOutput),
              ],
            ),
          ),
        ));
  }
}
