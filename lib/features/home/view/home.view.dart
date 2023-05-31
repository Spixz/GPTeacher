import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpteacher/features/get_int_injector.dart';
import 'package:gpteacher/features/home/view/components/agent_output.component.dart';
import 'package:gpteacher/features/home/view/components/language_level_selector.component.dart';
import 'package:gpteacher/features/home/view/components/prompt_user_message.component.dart';
import 'package:gpteacher/features/home/view/components/subject_selector.component.dart';
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
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: size.height,
            child: Column(
              children: const [
                LanguageLevelSelector(),
                SizedBox(height: 20),
                SubjectSelector(),
                SizedBox(height: 10),
                VoiceTTSControls(),
                AgentOutput(),
                PromptUserMessage()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
