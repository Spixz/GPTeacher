import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpteacher/constants/colors.dart';
import 'package:gpteacher/features/home/view_model/home.viewmodel.dart';

class VoiceTTSControls extends ConsumerWidget {
  const VoiceTTSControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
            backgroundColor: oldButtonColor, // <-- Button color
            // foregroundColor: Colors.red, // <-- Splash color
          ),
          onPressed: () {
            ref
                .read(homeViewModelProvider.notifier)
                .changeTTSState(!state.ttsEnabled);
          },
          child: (state.ttsEnabled)
              ? const Icon(
                  Icons.volume_up,
                  size: 30,
                  color: oldButtonInternal,
                )
              : const Icon(
                  Icons.volume_off,
                  size: 30,
                  color: oldButtonInternal,
                ),
        ),
        const SizedBox(width: 180),
        // const SizedBox(width: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
            backgroundColor: oldButtonColor, // <-- Button color
            // foregroundColor: Colors.red, // <-- Splash color
          ),
          child: (state.isListeningAudio)
              ? const Icon(
                  Icons.keyboard_voice,
                  size: 30,
                  color: oldButtonInternal,
                )
              : const Icon(
                  Icons.mic_off,
                  size: 30,
                  color: oldButtonInternal,
                ),
          onPressed: () {
            ref
                .read(homeViewModelProvider.notifier)
                .changeAudioRecordingState(!state.isListeningAudio);
          },
        ),
      ],
    );
  }
}
