enum LanguageLevel {
  beginner('beginner'),
  intermediate('intermediate'),
  expert('expert');

  const LanguageLevel(this.value);
  final String value;
  @override
  String toString() => value;
  static LanguageLevel fromString(String value) {
    return LanguageLevel.values
        .firstWhere((element) => element.toString() == value);
  }
}
