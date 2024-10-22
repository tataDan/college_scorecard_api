abstract class Constants {
  static const String collegeScorecardApiKey = String.fromEnvironment(
    'COLLEGE_SCORECARD_API_KEY',
    defaultValue: '',
  );
}
