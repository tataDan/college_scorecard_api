class CollegeScorecardException implements Exception {
  String message;
  CollegeScorecardException([this.message = 'Something went wrong']) {
    message = 'College Scorecard Exception: $message';
  }

  @override
  String toString() {
    return message;
  }
}
