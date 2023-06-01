import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpteacher/constants/colors.dart';
import 'package:gpteacher/features/home/view_model/home.viewmodel.dart';

class PromptUserMessage extends ConsumerStatefulWidget {
  const PromptUserMessage({super.key});

  @override
  ConsumerState<PromptUserMessage> createState() => _PromptUserMessageState();
}

class _PromptUserMessageState extends ConsumerState<PromptUserMessage> {
  late TextEditingController messageController;
  late FocusNode promptFocusNode;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
    promptFocusNode = FocusNode();
    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  @override
  void dispose() {
    messageController.dispose();
    ServicesBinding.instance.keyboard.removeHandler(_onKey);

    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;
    if (event is KeyDownEvent && key == LogicalKeyboardKey.enter.keyLabel) {
      askToGpt();
    }
    return false;
  }

  void askToGpt() {
    ref.read(homeViewModelProvider.notifier).askToGPT2(messageController.text);
    ref.read(homeViewModelProvider.notifier).userInput = "";
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(homeViewModelProvider, (prev, next) {
      ////prev!.userInput != next.userInput /*&& next.isListeningAudio*/) {
      // print("Changement du controlelr a patir du state");
      // print('Valeur du controller : ${messageController.text}');
      // print('Valeur du state : ${next.userInput}');
      messageController.text = next.userInput;
    });

    final state = ref.watch(homeViewModelProvider);

    return Container(
      constraints: const BoxConstraints(minHeight: 50, maxHeight: 150),
      decoration: BoxDecoration(
        color: oldInputTextBoxColor,
        // border: Border.all(color: secondaryColor),
        boxShadow: [
          BoxShadow(
            blurStyle: BlurStyle.outer,
            color: Colors.black.withOpacity(0.5),
            // spreadRadius: 1,
            blurRadius: 20,
            // offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
          // bottomRight: Radius.circular(20), // Si vous souhaitez arrondir également le coin inférieur droit
        ),
      ),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 15),
              child: TextField(
                // textInputAction: TextInputAction.go,
                controller: messageController,
                focusNode: promptFocusNode,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                style: const TextStyle(color: oldInputTextColor),
                decoration: const InputDecoration(
                  hintText: "Message",
                  hintStyle: TextStyle(color: oldInputTextColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide:
                          BorderSide(width: 0, style: BorderStyle.none)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  fillColor: oldInputTextBoxColor,
                  filled: true,
                ),
                onChanged: (value) {
                  if (!state.isListeningAudio) {
                    print("Dans le on changed");
                    print('Valeur du para : $value');
                    ref.read(homeViewModelProvider.notifier).userInput = value;
                    messageController.selection = TextSelection.fromPosition(
                        TextPosition(offset: messageController.text.length));
                  }
                },
                onSubmitted: (value) async {
                  askToGpt();
                },
                onTap: () {
                  if (state.isListeningAudio) {
                    print("On tap stop listening");
                    ref
                        .read(homeViewModelProvider.notifier)
                        .changeAudioRecordingState(false);
                  }
                },
              ),
            ),
          ),
          IconButton(
              onPressed: askToGpt,
              icon: const Icon(Icons.send, color: oldSendButtonColor)),
        ],
      ),
    );
  }
}
