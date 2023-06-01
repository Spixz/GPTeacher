import 'package:flutter/material.dart';
import 'package:gpteacher/features/home/view/components/language_level_selector.component.dart';
import 'package:gpteacher/features/home/view/components/subject_selector.component.dart';

class ConversationParameters extends StatefulWidget {
  const ConversationParameters({super.key});

  @override
  State<ConversationParameters> createState() => _ConversationParametersState();
}

class _ConversationParametersState extends State<ConversationParameters> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        LanguageLevelSelector(),
        const SizedBox(width: 20),
        const SubjectSelector(),
      ]),
    );
  }
}
