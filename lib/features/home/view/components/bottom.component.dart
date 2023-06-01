import 'package:flutter/material.dart';
import 'package:gpteacher/features/home/view/components/prompt_user_message.component.dart';
import 'package:gpteacher/features/home/view/components/voice_tts_controls.component.dart';

class Bottom extends StatelessWidget {
  const Bottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                height: 18,
              ),
              const PromptUserMessage(),
            ],
          ),
          const Positioned(top: 0, child: VoiceTTSControls()),
        ]);
  }
}
