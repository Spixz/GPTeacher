import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpteacher/constants/colors.dart';
import 'package:gpteacher/features/get_int_injector.dart';
import 'package:gpteacher/features/home/view/components/agent_output.component.dart';
import 'package:gpteacher/features/home/view/components/conversation_parameters.component.dart';
import 'package:gpteacher/features/home/view/components/header.component.dart';
import 'package:gpteacher/features/home/view/components/prompt_user_message.component.dart';
import 'package:gpteacher/features/home/view/components/voice_tts_controls.component.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    locator
        .getAsync<Mixpanel>()
        .then((mixpanel) => mixpanel.track("Ouverture de l'app"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: oldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: size.height,
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Header(),
                const SizedBox(height: 30),
                const ConversationParameters(),
                const SizedBox(height: 30),
                // VoiceTTSControls(),
                const AgentOutput(),
                Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: const [
                      PromptUserMessage(),
                      Positioned(
                          top: -28, child: VoiceTTSControls()),
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
