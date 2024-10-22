import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../exceptions/college_scorecard_exception.dart';
import '../models/college_scorecard.dart';
import 'http_error_handler.dart';

class CollegeScorecardApiServices {
  const CollegeScorecardApiServices({
    required this.httpClient,
  });

  final http.Client httpClient;

  Future<CollegeScorecard> getCollegeScorecardResponse(
      Map<String, String> searchValues, int page) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: 'api.data.gov',
      path: 'ed/collegescorecard/v1/schools',
      queryParameters: {
        ...searchValues,
        'page': page.toString(),
        'fields': 'latest.school.name,latest.school.city,latest.school.state,'
            'latest.school.school_url,latest.school.price_calculator_url,'
            'latest.student.size,latest.student.grad_students,'
            'latest.cost.tuition.in_state,latest.cost.tuition.out_of_state,'
            'latest.programs.cip_4_digit.code,latest.programs.cip_4_digit.title',
        'api_key': Constants.collegeScorecardApiKey,
      },
    );

    try {
      final http.Response response = await httpClient.get(uri);

      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }

      final responseBody = json.decode(response.body);

      if (responseBody.isEmpty) {
        throw CollegeScorecardException('No Documents Were Found');
      }

      final collegeScorecard = CollegeScorecard.fromJson(responseBody);

      return collegeScorecard;
    } catch (e) {
      rethrow;
    }
  }
}
