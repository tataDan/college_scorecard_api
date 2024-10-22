import '../exceptions/college_scorecard_exception.dart';
import '../models/custom_error.dart';
import '../models/college_scorecard.dart';
import '../services/college_scorecard_api_services.dart';

class CollegeScorecardRepository {
  const CollegeScorecardRepository({
    required this.collegeScorecardApiServices,
  });

  final CollegeScorecardApiServices collegeScorecardApiServices;

  Future<CollegeScorecard> fetchCollegeScorecard(
      Map<String, String> searchValues, int page) async {
    try {
      final CollegeScorecard collegeScorecard =
          await collegeScorecardApiServices.getCollegeScorecardResponse(
              searchValues, page);

      return collegeScorecard;
    } on CollegeScorecardException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
