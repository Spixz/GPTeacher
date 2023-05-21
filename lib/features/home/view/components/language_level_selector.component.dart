import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpteacher/features/home/view_model/home.viewmodel.dart';

class LanguageLevelSelector extends ConsumerWidget {
  const LanguageLevelSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);

    return DropdownButton<String>(
      value: ref.watch(homeViewModelProvider).selectedLanguageLevel.toString(),
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        if (value != null) {
          ref.read(homeViewModelProvider.notifier).setLanguageLevel(value);
        }
      },
      items: List<DropdownMenuItem<String>>.generate(
          state.availaibleLanguageLevel.length, (index) {
        return DropdownMenuItem<String>(
          value: state.availaibleLanguageLevel[index].toString(),
          child: Text(state.availaibleLanguageLevel[index].toString()),
        );
      }),
    );
  }
}
