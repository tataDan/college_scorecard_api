import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'cubits/cubits.dart';
import 'pages/home_page.dart';
import 'repositories/college_scorecard_repository.dart';
import 'services/college_scorecard_api_services.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CollegeScorecardRepository(
        collegeScorecardApiServices: CollegeScorecardApiServices(
          httpClient: http.Client(),
        ),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CollegeScorecardCubit>(
            create: (context) => CollegeScorecardCubit(
              collegeScorecardRepository:
                  context.read<CollegeScorecardRepository>(),
            ),
          ),
          BlocProvider<SearchValuesCubit>(
            create: (context) => SearchValuesCubit(newSearchValues: {}),
          ),
          BlocProvider<PageCubit>(
            create: (context) => PageCubit(),
          ),
        ],
        child: const MaterialApp(
          title: 'College Scorecare Api',
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        ),
      ),
    );
  }
}
