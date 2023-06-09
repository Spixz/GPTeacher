import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpteacher/constants/colors.dart';
import 'package:gpteacher/features/home/view_model/home.viewmodel.dart';

class AgentOutput extends ConsumerWidget {
  const AgentOutput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);

    return Expanded(
        flex: 6,
        child: Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.all(10),
            child: SingleChildScrollView(
                controller: ref
                    .read(homeViewModelProvider.notifier)
                    .scrollControllerAgentOutput,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(10),
                physics: const RangeMaintainingScrollPhysics(),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(ref.watch(homeViewModelProvider).agentOutput,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.brawler(
                            textStyle: const TextStyle(
                          fontSize: 18,
                          color: oldTextColor,
                        )))))));
  }
}
