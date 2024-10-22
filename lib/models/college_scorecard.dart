class Metadata {
  final int page;
  final int total;
  final int perPage;

  Metadata({
    required this.page,
    required this.total,
    required this.perPage,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      page: json['page'],
      total: json['total'],
      perPage: json['per_page'],
    );
  }
}

class CipProgram {
  final String code;
  final String title;

  CipProgram({
    required this.code,
    required this.title,
  });

  factory CipProgram.fromJson(Map<String, dynamic> json) {
    return CipProgram(
      code: json['code'],
      title: json['title'],
    );
  }
}

class Result {
  final String schoolName;
  final String schoolCity;
  final String schoolState;
  final String schoolSchoolUrl;
  final String schoolSchoolPriceCalculatorUrl;
  final int studentSize;
  final int studentGradStudents;
  final int costTuitionInState;
  final int costTuitionOutOfState;
  final List<CipProgram>? cipPrograms;

  Result({
    required this.schoolName,
    required this.schoolCity,
    required this.schoolState,
    required this.schoolSchoolUrl,
    required this.schoolSchoolPriceCalculatorUrl,
    required this.studentSize,
    required this.studentGradStudents,
    required this.costTuitionInState,
    required this.costTuitionOutOfState,
    this.cipPrograms,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return json['latest.programs.cip_4_digit'] != null
        ? Result(
            schoolName: json['latest.school.name'] ?? '',
            schoolCity: json['latest.school.city'] ?? '',
            schoolState: json['latest.school.state'] ?? '',
            schoolSchoolUrl: json['latest.school.school_url'] ?? '',
            schoolSchoolPriceCalculatorUrl:
                json['latest.school.price_calculator_url'] ?? '',
            studentSize: json['latest.student.size'] ?? 0,
            studentGradStudents: json['latest.student.grad_students'] ?? 0,
            costTuitionInState: json['latest.cost.tuition.in_state'] ?? 0,
            costTuitionOutOfState:
                json['latest.cost.tuition.out_of_state'] ?? 0,
            cipPrograms: (json['latest.programs.cip_4_digit'] as List)
                .map((i) => CipProgram.fromJson(i))
                .toList())
        : Result(
            schoolName: json['latest.school.name'] ?? '',
            schoolCity: json['latest.school.city'] ?? '',
            schoolState: json['latest.school.state'] ?? '',
            schoolSchoolUrl: json['latest.school.school_url'] ?? '',
            schoolSchoolPriceCalculatorUrl:
                json['latest.school.price_calculator_url'] ?? '',
            studentSize: json['latest.student.size'] ?? 0,
            studentGradStudents: json['latest.student.grad_students'] ?? 0,
            costTuitionInState: json['latest.cost.tuition.in_state'] ?? 0,
            costTuitionOutOfState:
                json['latest.cost.tuition.out_of_state'] ?? 0,
          );
  }
}

class CollegeScorecard {
  final Metadata metadata;
  final List<Result> results;

  CollegeScorecard({
    required this.metadata,
    required this.results,
  });

  factory CollegeScorecard.fromJson(Map<String, dynamic> json) {
    return CollegeScorecard(
      metadata: Metadata.fromJson(
        json['metadata'],
      ),
      results:
          (json['results'] as List).map((i) => Result.fromJson(i)).toList(),
    );
  }

  factory CollegeScorecard.initial() => CollegeScorecard(
        metadata: Metadata(page: 0, total: 0, perPage: 0),
        results: [],
      );
}
