import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpteacher/features/home/view_model/home.viewmodel.dart';

class SubjectSelector extends ConsumerWidget {
  const SubjectSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);

    return DropdownButton<String>(
      value: ref.watch(homeViewModelProvider).selectedSubject,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        if (value != null) {
          ref.read(homeViewModelProvider.notifier).setSelectedSubject(value);
        }
      },
      items: List<DropdownMenuItem<String>>.generate(
          state.availaibleSubjects.length, (index) {
        return DropdownMenuItem<String>(
          value: state.availaibleSubjects[index],
          child: Text(state.availaibleSubjects[index]),
        );
      }),
    );
  }
}
