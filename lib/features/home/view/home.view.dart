import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpteacher/constants/colors.dart';
import 'package:gpteacher/constants/secret_keys.dart';
import 'package:gpteacher/features/get_int_injector.dart';
import 'package:gpteacher/features/home/view/components/agent_output.component.dart';
import 'package:gpteacher/features/home/view/components/bottom.component.dart';
import 'package:gpteacher/features/home/view/components/conversation_parameters.component.dart';
import 'package:gpteacher/features/home/view/components/header.component.dart';
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
          child: Container(
            height: size.height,
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: const [
                // Text(decoder(OPENAI_KEY)),
                SizedBox(height: 30),
                Header(),
                SizedBox(height: 30),
                ConversationParameters(),
                SizedBox(height: 30),
                AgentOutput(),
                Bottom()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
