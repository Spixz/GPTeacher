import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpteacher/features/home/view_model/home.viewmodel.dart';
import 'package:gpteacher/localization/string_hardcoded.dart';

class VoiceTTSControls extends ConsumerWidget {
  const VoiceTTSControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: (state.ttsEnabled)
              ? const Icon(
                  Icons.volume_up,
                  size: 40,
                )
              : const Icon(
                  Icons.volume_off,
                  size: 40,
                ),
          tooltip: (state.ttsEnabled)
              ? 'Disable voice synthesis'.hardcoded
              : 'Enable voice synthesis'.hardcoded,
          onPressed: () {
            ref
                .read(homeViewModelProvider.notifier)
                .changeTTSState(!state.ttsEnabled);
          },
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: (state.isListeningAudio)
              ? const Icon(
                  Icons.keyboard_voice,
                  size: 40,
                )
              : const Icon(
                  Icons.mic_off,
                  size: 40,
                ),
          tooltip: (state.isListeningAudio)
              ? 'Disable voice recognition'.hardcoded
              : 'Enable voice recognition'.hardcoded,
          onPressed: () {
            ref
                .read(homeViewModelProvider.notifier)
                .changeAudioRecordingState(!state.isListeningAudio);
          },
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
