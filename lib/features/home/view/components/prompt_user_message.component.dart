import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      padding: const EdgeInsets.all(10),
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
                decoration: const InputDecoration(
                  hintText: "Message",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide:
                          BorderSide(width: 0, style: BorderStyle.none)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  fillColor: Color.fromARGB(255, 109, 109, 109),
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
              icon: const Icon(Icons.send, color: Colors.grey)),
        ],
      ),
    );
  }
}
