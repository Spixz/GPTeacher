import 'package:flutter/material.dart';
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
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void submitMessage(String msg) {
    // widget.submitMessage(msg);
    messageController.clear();
    promptFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(homeViewModelProvider, (prev, next) {
      if (prev!.userInput != next.userInput) {
        messageController.text = next.userInput;
      }
    });

    return Container(
      constraints: const BoxConstraints(minHeight: 50, maxHeight: 150),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 15),
              child: TextField(
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
                      filled: true),
                  onSubmitted: (text) => (text)),
            ),
          ),
          // IconButton(
          //     onPressed: () {
          //       selectAndSendFile();
          //     },
          //     icon: const Icon(Icons.camera_alt, color: Colors.grey)),
        ],
      ),
    );
  }
}
