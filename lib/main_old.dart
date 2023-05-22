//
// Copyright 2022 Picovoice Inc.
//
// You may not use this file except in compliance with the license. A copy of the license is located in the "LICENSE"
// file accompanying this source.
//
// Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//

import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:cheetah_flutter/cheetah_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:gpteacher/cheetah_manager.dart';

class TTS {
  FlutterTts flutterTts = FlutterTts();
  String gptOutputBuff = "";
  Queue<String> gptOutputQueue = Queue();
  bool isSpeaking = false;
  int ttsReadingCout = 0;
  int totalNumberOfCuts = 0;
  String transcriptText = "";

  Future<void> initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.5);

    flutterTts.setCompletionHandler(() {
      gptOutputQueue.removeLast();
      isSpeaking = false;
      ttsReadingCout++;
      if (totalNumberOfCuts == ttsReadingCout) {
        totalNumberOfCuts = 0;
        ttsReadingCout = 0;
        transcriptText = "";
        gptOutputBuff = "";
        gptOutputQueue.clear();
        print("de nouveau en écoute");
        //TODO: _startProcessing(); //GetIT ou dans la même classe
      }
      if (gptOutputQueue.isNotEmpty) {
        isSpeaking = true;
        _speak(gptOutputQueue.last);
      }
    });
    // await flutterTts.setVoice({"name": "en-us-x-sfg#male_1-local"});
    // await flutterTts.setSharedInstance(true);
  }


    Future _speak(String text) async {
    // _stopProcessing(); TODO: Chetah get it
    flutterTts.speak(text);
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String accessKey =
      'iucMFDyWvdaKiUzqtipwoQ4jiNSweUIzlUAAxhua49hi/iZHUd+Axw=='; // AccessKey obtained from Picovoice Console (https://console.picovoice.ai/)
  final openAI = OpenAI.instance.build(
      token: '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',
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)));

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isError = false;
  String errorMessage = "";

  bool isProcessing = false;
  String transcriptText = "";
  String gptOutputBuff = "";
  bool isSpeaking = false;
  int totalNumberOfCuts = 0;
  int ttsReadingCout = 0;
  String userInput = "";
  String previousGptAnswer = "";

  Queue<String> gptOutputQueue = Queue();

  CheetahManager? _cheetahManager;
  FlutterTts flutterTts = FlutterTts();

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    setState(() {
      // transcriptText = "";
      // ttsState = ;
    });

    initCheetah();
    initTts();
  }

  Future<void> initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.5);

    flutterTts.setCompletionHandler(() {
      gptOutputQueue.removeLast();
      isSpeaking = false;
      ttsReadingCout++;
      if (totalNumberOfCuts == ttsReadingCout) {
        totalNumberOfCuts = 0;
        ttsReadingCout = 0;
        transcriptText = "";
        gptOutputBuff = "";
        gptOutputQueue.clear();
        print("de nouveau en écoute");
        _startProcessing();
      }
      if (gptOutputQueue.isNotEmpty) {
        isSpeaking = true;
        _speak(gptOutputQueue.last);
      }
    });
    // await flutterTts.setVoice({"name": "en-us-x-sfg#male_1-local"});
    // await flutterTts.setSharedInstance(true);
  }

  Future<void> initCheetah() async {
    String platform = Platform.isAndroid
        ? "android"
        : Platform.isIOS
            ? "ios"
            : throw CheetahRuntimeException(
                "This demo supports iOS and Android only.");
    String modelPath = "assets/models/$platform/cheetah_params.pv";

    try {
      _cheetahManager = await CheetahManager.create(
          accessKey, modelPath, transcriptCallback, errorCallback);
    } on CheetahInvalidArgumentException catch (ex) {
      errorCallback(CheetahInvalidArgumentException(
          "${ex.message}\nEnsure your accessKey '$accessKey' is a valid access key."));
    } on CheetahActivationException {
      errorCallback(CheetahActivationException("AccessKey activation error."));
    } on CheetahActivationLimitException {
      errorCallback(CheetahActivationLimitException(
          "AccessKey reached its device limit."));
    } on CheetahActivationRefusedException {
      errorCallback(CheetahActivationRefusedException("AccessKey refused."));
    } on CheetahActivationThrottledException {
      errorCallback(
          CheetahActivationThrottledException("AccessKey has been throttled."));
    } on CheetahException catch (ex) {
      errorCallback(ex);
    }
  }

  void transcriptCallback(String transcript) {
    bool shouldScroll =
        _controller.position.pixels == _controller.position.maxScrollExtent;

    setState(() {
      transcriptText = transcriptText + transcript;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (shouldScroll && !_controller.position.atEdge) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
  }

  Future _speak(String text) async {
    _stopProcessing();
    flutterTts.speak(text);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    // if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  void addNewSentenceToQueue(String newSentence) {
    gptOutputQueue.addFirst(newSentence);
    if (isSpeaking != true && gptOutputQueue.length == 1) {
      isSpeaking = true;
      print("Speak de $newSentence");
      _speak(gptOutputQueue.last);
    }
  }

  void chatComplete(String userInput) {
    final request = ChatCompleteText(messages: [
      Map.of({"role": "user", "content": userInput})
    ], maxToken: 100, model: ChatModel.gptTurbo);

    openAI.onChatCompletionSSE(request: request).listen((it) async {
      if (it.choices.last.message?.content != null) {
        String newEntry = it.choices.last.message!.content;
        gptOutputBuff += newEntry;
        if (['.', ',', '? ', '! '].contains(newEntry)) {
          totalNumberOfCuts++;
          addNewSentenceToQueue(gptOutputBuff);
          gptOutputBuff = "";
        }
      }
      debugPrint(it.choices.last.message?.content);
    }, onDone: () {});
  }

  void chatCompleteDebug(String userInput) {
    List<Map<String, String>> messages;
    if (userInput.isEmpty) {
      messages = [
        {
          "role": "system",
          "content":
              "Tu est un serveur de restaurant qui sert un clients et l'accompagne à toutes les étapes de son repas. A la fin de t'as réponse, écrit les mots les plus important relatif à t'as ou sa réponse qui vont te permettre de prendre de futur décision."
        },
        {
          "role": "user",
          "content":
              "Le client entre dans l'établissement, acceuille le par une phrase."
        }
      ];
    } else {
      messages = [
        {
          "role": "system",
          "content":
              "Tu est un serveur de restaurant qui sert un clients et l'accompagne à toutes les étapes de son repas. A la fin de t'as réponse, stock les infos infos importantes sous cette forme: clients: x, plat princiapl: y, boisson: r"
        },
        {"role": "assistant", "content": previousGptAnswer},
        {"role": "user", "content": userInput},
      ];
    }
    print("GPT request:");
    print(messages);
    final request = ChatCompleteText(
        messages: messages, maxToken: 100, model: ChatModel.gptTurbo);

    openAI.onChatCompletionSSE(request: request).listen((it) async {
      if (it.choices.last.message?.content != null) {
        String newEntry = it.choices.last.message!.content;
        gptOutputBuff += newEntry;
        if (['.', ',', '? ', '! '].contains(newEntry)) {
          // print(gptOutputBuff);
        }
      }
      // debugPrint(it.choices.last.message?.content);
    }, onDone: () {
      print(gptOutputBuff);
      previousGptAnswer = gptOutputBuff;
      gptOutputBuff = "";
    });
  }

  buildUserInput(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (text) {
                setState(() {
                  userInput = text;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                chatCompleteDebug(userInput);
                setState(() {
                  userInput = "";
                });
              },
              child: Text("Send"),
            )
          ],
        ),
      ),
    );
  }

  void errorCallback(CheetahException error) {
    setState(() {
      isError = true;
      errorMessage = error.message!;
    });
  }

  Future<void> _startProcessing() async {
    if (isProcessing) {
      return;
    }

    try {
      await _cheetahManager!.startProcess();
      setState(() {
        transcriptText = "";
        isProcessing = true;
      });
    } on CheetahException catch (ex) {
      print("Failed to start audio capture: ${ex.message}");
    }
  }

  Future<void> _stopProcessing() async {
    if (!isProcessing) {
      return;
    }

    try {
      await _cheetahManager!.stopProcess();
      setState(() {
        isProcessing = false;
      });
    } on CheetahException catch (ex) {
      print("Failed to start audio capture: ${ex.message}");
    }
  }

  Color picoBlue = Color.fromRGBO(55, 125, 255, 1);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Cheetah Demo'),
          backgroundColor: picoBlue,
        ),
        body: Column(
          children: [
            buildCheetahTextArea(context),
            buildErrorMessage(context),
            buildUserInput(context),
            Row(
              children: [
                buildStartButton(context),
                buildSpeechButton(context),
                buildGptButton(context),
              ],
            ),
            footer
          ],
        ),
      ),
    );
  }

  buildStartButton(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        backgroundColor: picoBlue,
        shape: CircleBorder(),
        textStyle: TextStyle(color: Colors.white));

    return Expanded(
      flex: 2,
      child: Container(
          child: SizedBox(
              width: 90,
              height: 90,
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: isError
                    ? null
                    : isProcessing
                        ? _stopProcessing
                        : _startProcessing,
                child: Text(isProcessing ? "Stop" : "Start",
                    style: TextStyle(fontSize: 30)),
              ))),
    );
  }

  buildSpeechButton(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        backgroundColor: picoBlue,
        shape: CircleBorder(),
        textStyle: TextStyle(color: Colors.white));

    return Expanded(
      flex: 2,
      child: Container(
          child: SizedBox(
              width: 90,
              height: 90,
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: isError
                    ? null
                    : isProcessing
                        ? _stopProcessing
                        : () => _speak(transcriptText),
                child: Text(isProcessing ? "Stop Proc" : "Start speak",
                    style: TextStyle(fontSize: 30)),
              ))),
    );
  }

  buildGptButton(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        backgroundColor: picoBlue,
        shape: CircleBorder(),
        textStyle: TextStyle(color: Colors.white));

    return Expanded(
      flex: 2,
      child: Container(
          child: SizedBox(
              width: 90,
              height: 90,
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: isError ? null : () => chatComplete(transcriptText),
                child: Text(isProcessing ? "Stop Proc" : "GPT",
                    style: TextStyle(fontSize: 30)),
              ))),
    );
  }

  buildCheetahTextArea(BuildContext context) {
    return Expanded(
        flex: 6,
        child: Container(
            alignment: Alignment.topCenter,
            color: Color(0xff25187e),
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
                controller: _controller,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(10),
                physics: RangeMaintainingScrollPhysics(),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      transcriptText,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )))));
  }

  buildErrorMessage(BuildContext context) {
    return Expanded(
        flex: isError ? 2 : 0,
        child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: EdgeInsets.all(5),
            decoration: !isError
                ? null
                : BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(5)),
            child: !isError
                ? null
                : Text(
                    errorMessage,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )));
  }

  Widget footer = Expanded(
      flex: 1,
      child: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 20),
          child: const Text(
            "Made in dVancouver, Canada by Picovoice",
            style: TextStyle(color: Color(0xff666666)),
          )));
}
