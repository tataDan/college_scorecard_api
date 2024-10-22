import '../models/college_scorecard.dart';

class FilterResults {
  List<Result> results;
  Map<String, String> resultsFilters;
  FilterResults({
    required this.results,
    required this.resultsFilters,
  });

  List<Result> get filteredResults {
    List<Result> filteredResults = [];

    for (Result result in results) {
      if (!filtered(result)) {
        filteredResults.add(result);
      }
    }

    return filteredResults;
  }

  bool filtered(Result result) {
    String? studentSizeMinStr = '';
    String? studentSizeMaxStr = '';
    String? gradStudentsMinStr = '';
    String? gradStudentsMaxStr = '';
    String? inStateTuitionMaxStr = '';
    String? outOfStateTuitionMaxStr = '';
    int studentSizeMinNum = 0;
    int studentSizeMaxNum = 0;
    int gradStudentsMinNum = 0;
    int gradStudentsMaxNum = 0;
    int inStateTuitionMaxNum = 0;
    int outOfStateTuitionMaxNum = 0;

    studentSizeMinStr = resultsFilters['studentSizeMin'];
    if (studentSizeMinStr!.isNotEmpty) {
      studentSizeMinNum = int.parse(studentSizeMinStr);
    }
    studentSizeMaxStr = resultsFilters['studentSizeMax'];
    if (studentSizeMaxStr!.isNotEmpty) {
      studentSizeMaxNum = int.parse(studentSizeMaxStr);
    }
    gradStudentsMinStr = resultsFilters['gradStudentsMin'];
    if (gradStudentsMinStr!.isNotEmpty) {
      gradStudentsMinNum = int.parse(gradStudentsMinStr);
    }
    gradStudentsMaxStr = resultsFilters['gradStudentsMax'];
    if (gradStudentsMaxStr!.isNotEmpty) {
      gradStudentsMaxNum = int.parse(gradStudentsMaxStr);
    }
    inStateTuitionMaxStr = resultsFilters['inStateTuitionMax'];
    if (inStateTuitionMaxStr!.isNotEmpty) {
      inStateTuitionMaxNum = int.parse(inStateTuitionMaxStr);
    }
    outOfStateTuitionMaxStr = resultsFilters['outOfStateTuitionMax'];
    if (outOfStateTuitionMaxStr!.isNotEmpty) {
      outOfStateTuitionMaxNum = int.parse(outOfStateTuitionMaxStr);
    }

    bool studentSizeMinFiltered =
        ((studentSizeMinNum > 0) && (result.studentSize < studentSizeMinNum));
    bool studentSizeMaxFiltered =
        ((studentSizeMaxNum > 0) && (result.studentSize > studentSizeMaxNum));
    bool gradStudentsMinFiltered = ((gradStudentsMinNum > 0) &&
        (result.studentGradStudents < gradStudentsMinNum));
    bool gradStudentsMaxFiltered = ((gradStudentsMaxNum > 0) &&
        (result.studentGradStudents > gradStudentsMaxNum));
    bool inStateTuitionMaxFiltered = ((inStateTuitionMaxNum > 0) &&
        (result.costTuitionInState > inStateTuitionMaxNum));
    bool outOfStateTuitionMaxFiltered = ((outOfStateTuitionMaxNum > 0) &&
        (result.costTuitionOutOfState > outOfStateTuitionMaxNum));

    if (studentSizeMinFiltered ||
        studentSizeMaxFiltered ||
        gradStudentsMinFiltered ||
        gradStudentsMaxFiltered ||
        inStateTuitionMaxFiltered ||
        outOfStateTuitionMaxFiltered) {
      return true;
    } else {
      return false;
    }
  }
}
