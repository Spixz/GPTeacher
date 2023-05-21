import 'dart:convert';
import 'package:gpteacher/enums/LanguageLevel.dart';

class HomeState {
  final List<LanguageLevel> availaibleLanguageLevel = [
    LanguageLevel.beginner,
    LanguageLevel.intermediate,
    LanguageLevel.expert
  ];
  final List<String> availaibleSubjects = ['At restaurant', 'In the bus'];
  final String agentOutput;
  final String userInput;

  final LanguageLevel selectedLanguageLevel;
  final String selectedSubject;
  final bool ttsEnabled;
  final bool isListeningAudio;

  HomeState({
    required this.selectedLanguageLevel,
    required this.selectedSubject,
    required this.ttsEnabled,
    required this.isListeningAudio,
    this.agentOutput = '',
    this.userInput = '',
  });

  HomeState copyWith({
    String? agentOutput,
    String? userInput,
    LanguageLevel? selectedLanguageLevel,
    String? selectedSubject,
    bool? ttsEnabled,
    bool? isListeningAudio,
  }) {
    return HomeState(
      selectedLanguageLevel:
          selectedLanguageLevel ?? this.selectedLanguageLevel,
      selectedSubject: selectedSubject ?? this.selectedSubject,
      ttsEnabled: ttsEnabled ?? this.ttsEnabled,
      isListeningAudio: isListeningAudio ?? this.isListeningAudio,
      agentOutput: agentOutput ?? this.agentOutput,
      userInput: userInput ?? this.userInput,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'selectedLanguageLevel': selectedLanguageLevel,
      'selectedSubject': selectedSubject,
      'ttsEnabled': ttsEnabled,
      'isListeningAudio': isListeningAudio,
      'agentOutput': agentOutput,
      'userInput': userInput,
    };
  }

  factory HomeState.fromMap(Map<String, dynamic> map) {
    return HomeState(
      selectedLanguageLevel: map['selectedLanguageLevel'] as LanguageLevel,
      selectedSubject: map['selectedSubject'] as String,
      ttsEnabled: map['ttsEnabled'] as bool,
      isListeningAudio: map['isListeningAudio'] as bool,
      agentOutput: map['agentOutput'] as String,
      userInput: map['userInput'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeState.fromJson(String source) =>
      HomeState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HomeState(selectedLanguageLevel: $selectedLanguageLevel, selectedSubject: $selectedSubject, ttsEnabled: $ttsEnabled, isListeningAudio: $isListeningAudio, agentOutput: $agentOutput, userInput: $userInput)';
  }

  @override
  bool operator ==(covariant HomeState other) {
    if (identical(this, other)) return true;

    return other.selectedLanguageLevel == selectedLanguageLevel &&
        other.selectedSubject == selectedSubject &&
        other.ttsEnabled == ttsEnabled &&
        other.isListeningAudio == isListeningAudio &&
        other.agentOutput == agentOutput &&
        other.userInput == userInput;
  }

  @override
  int get hashCode {
    return selectedLanguageLevel.hashCode ^
        selectedSubject.hashCode ^
        ttsEnabled.hashCode ^
        isListeningAudio.hashCode ^
        agentOutput.hashCode ^
        userInput.hashCode;
  }
}
