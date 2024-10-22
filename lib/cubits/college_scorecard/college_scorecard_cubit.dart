import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/custom_error.dart';
import '../../models/college_scorecard.dart';
import '../../repositories/college_scorecard_repository.dart';

part 'college_scorecard_state.dart';

class CollegeScorecardCubit extends Cubit<CollegeScorecardState> {
  final CollegeScorecardRepository collegeScorecardRepository;

  CollegeScorecardCubit({
    required this.collegeScorecardRepository,
  }) : super(CollegeScorecardState.initial());

  Future<void> fetchCollegeScorecard(
      Map<String, String> searchValues, int page) async {
    emit(state.copyWith(status: CollegeScorecardStatus.loading));

    try {
      final CollegeScorecard collegeScorecard = await collegeScorecardRepository
          .fetchCollegeScorecard(searchValues, page);

      emit(state.copyWith(
          status: CollegeScorecardStatus.loaded,
          collegeScorecard: collegeScorecard));
    } on CustomError catch (e) {
      emit(state.copyWith(status: CollegeScorecardStatus.error, error: e));
    }
  }
}
