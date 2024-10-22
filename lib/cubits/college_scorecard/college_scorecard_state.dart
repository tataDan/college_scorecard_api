part of 'college_scorecard_cubit.dart';

enum CollegeScorecardStatus {
  initial,
  loading,
  loaded,
  error,
}

class CollegeScorecardState extends Equatable {
  const CollegeScorecardState({
    required this.status,
    required this.collegeScorecard,
    required this.error,
  });

  factory CollegeScorecardState.initial() {
    return CollegeScorecardState(
      status: CollegeScorecardStatus.initial,
      collegeScorecard: CollegeScorecard.initial(),
      error: const CustomError(),
    );
  }

  final CollegeScorecardStatus status;
  final CollegeScorecard collegeScorecard;
  final CustomError error;

  @override
  List<Object> get props => [status, collegeScorecard, error];

  @override
  String toString() =>
      'CollegeScorecardState(status: $status, collegeScorecard: $collegeScorecard, error: $error)';

  CollegeScorecardState copyWith({
    CollegeScorecardStatus? status,
    CollegeScorecard? collegeScorecard,
    CustomError? error,
  }) {
    return CollegeScorecardState(
      status: status ?? this.status,
      collegeScorecard: collegeScorecard ?? this.collegeScorecard,
      error: error ?? this.error,
    );
  }
}
