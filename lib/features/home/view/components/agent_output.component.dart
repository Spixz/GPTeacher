import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            color: const Color(0xff25187e),
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
                    child: Text(
                      ref.watch(homeViewModelProvider).agentOutput,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    )))));
  }
}