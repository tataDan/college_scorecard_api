import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cubits.dart';
import '../utilities/filter_docs.dart';
import '../utilities/url_launcher.dart';
import '../models/college_scorecard.dart';
import '../widgets/error_dialog.dart';
import 'programs_list_page.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  Map<String, String>? _searchValues;
  final Map<String, String> _resultsFilters = {};
  int? _page;
  int schoolCountBase = 1;

  Map<int, int> pageCounts = {};
  Map<int, int> pageCountsFiltered = {};

  final TextEditingController _studentSizeMinController =
      TextEditingController();
  final TextEditingController _studentSizeMaxController =
      TextEditingController();
  final TextEditingController _gradStudentsMinController =
      TextEditingController();
  final TextEditingController _gradStudentsMaxController =
      TextEditingController();
  final TextEditingController _inStateTuitionMaxController =
      TextEditingController();
  final TextEditingController _outOfStateTuitionMaxController =
      TextEditingController();
  bool filtersApplied = false;

  @override
  void dispose() {
    _studentSizeMinController.dispose();
    _studentSizeMaxController.dispose();
    _gradStudentsMinController.dispose();
    _gradStudentsMaxController.dispose();
    _inStateTuitionMaxController.dispose();
    _outOfStateTuitionMaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collegeScorecardCubit = context.read<CollegeScorecardCubit>();

    _searchValues = context.watch<SearchValuesCubit>().state.searchValues;
    _page = context.watch<PageCubit>().state.page;

    collegeScorecardCubit.fetchCollegeScorecard(_searchValues!, _page!);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('College Scorecare API'),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<PageCubit>().resetToZero();
              Navigator.pop(context, true);
            }),
      ),
      body: BlocConsumer<CollegeScorecardCubit, CollegeScorecardState>(
        listener: (context, state) {
          if (state.status == CollegeScorecardStatus.error) {
            errorDialog(context, state.error.errMsg);
          }
        },
        builder: (context, state) {
          List<Result> results = state.collegeScorecard.results;
          int total = state.collegeScorecard.metadata.total;
          int perPage = state.collegeScorecard.metadata.perPage;

          if (filtersApplied) {
            results = FilterResults(
              results: results,
              resultsFilters: _resultsFilters,
            ).filteredResults;
            pageCountsFiltered[_page!] = results.length;
          } else {
            pageCounts[_page!] = results.length;
          }

          if (state.status == CollegeScorecardStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.collegeScorecard.results.isEmpty) {
            return const Center(
              child: Text(
                'NO RESULTS WERE FOUND',
                style: TextStyle(fontSize: 20.0),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              primary: true,
              scrollDirection: Axis.vertical,
              children: [
                showPageRow(total, perPage, context),
                const SizedBox(height: 10.0),
                showFilters(),
                const Divider(),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return showDoc(index, results);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Padding showPageRow(int total, int perPage, BuildContext context) {
    int pageToShow = _page! + 1;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children: [
          Text(
            'Page: $pageToShow',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 10.0),
          ElevatedButton(
            onPressed: _page! >= (total ~/ perPage)
                ? null
                : () {
                    BlocProvider.of<PageCubit>(context).increment();
                    if (filtersApplied) {
                      schoolCountBase += pageCountsFiltered[_page!]!;
                    } else {
                      schoolCountBase += pageCounts[_page!]!;
                    }
                  },
            child: const Text('Next Page'),
          ),
          const SizedBox(width: 10.0),
          ElevatedButton(
            onPressed: _page! < 1
                ? null
                : () {
                    BlocProvider.of<PageCubit>(context).decrement();
                    if (filtersApplied) {
                      schoolCountBase -= pageCountsFiltered[_page! - 1]!;
                    } else {
                      schoolCountBase -= pageCounts[_page! - 1]!;
                    }
                  },
            child: const Text('Previous Page'),
          ),
          const SizedBox(width: 20.0),
          Text(
            'Schools found: ${total.toString()}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Padding showFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              const Text(
                'Filters:',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(width: 17.0),
              SizedBox(
                width: 160.0,
                child: TextField(
                  controller: _studentSizeMinController,
                  decoration: const InputDecoration(
                    labelText: 'Min Student Size',
                    border: OutlineInputBorder(),
                  ),
                  enabled: _page! == 0 ? true : false,
                ),
              ),
              const SizedBox(width: 17.0),
              SizedBox(
                width: 160.0,
                child: TextField(
                  controller: _studentSizeMaxController,
                  decoration: const InputDecoration(
                    labelText: 'Max Student Size',
                    border: OutlineInputBorder(),
                  ),
                  enabled: _page! == 0 ? true : false,
                ),
              ),
              const SizedBox(width: 17.0),
              SizedBox(
                width: 170.0,
                child: TextField(
                  controller: _gradStudentsMinController,
                  decoration: const InputDecoration(
                    labelText: 'Min Grad Students',
                    border: OutlineInputBorder(),
                  ),
                  enabled: _page! == 0 ? true : false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Wrap(
            children: [
              SizedBox(
                width: 170.0,
                child: TextField(
                  controller: _gradStudentsMaxController,
                  decoration: const InputDecoration(
                    labelText: 'Max Grad Students',
                    border: OutlineInputBorder(),
                  ),
                  enabled: _page! == 0 ? true : false,
                ),
              ),
              const SizedBox(width: 17.0),
              SizedBox(
                width: 175.0,
                child: TextField(
                  controller: _inStateTuitionMaxController,
                  decoration: const InputDecoration(
                    labelText: 'Max In-state Tuition',
                    border: OutlineInputBorder(),
                  ),
                  enabled: _page! == 0 ? true : false,
                ),
              ),
              const SizedBox(width: 17.0),
              SizedBox(
                width: 210.0,
                child: TextField(
                  controller: _outOfStateTuitionMaxController,
                  decoration: const InputDecoration(
                    labelText: 'Max Out-of-state Tuition',
                    border: OutlineInputBorder(),
                  ),
                  enabled: _page! == 0 ? true : false,
                ),
              ),
              const SizedBox(width: 15.0),
              ElevatedButton(
                onPressed: _page! == 0
                    ? () {
                        if (_studentSizeMinController.text.trim().isNotEmpty) {
                          _resultsFilters['studentSizeMin'] =
                              _studentSizeMinController.text.trim();
                        } else {
                          _resultsFilters['studentSizeMin'] = '';
                        }
                        if (_studentSizeMaxController.text.trim().isNotEmpty) {
                          _resultsFilters['studentSizeMax'] =
                              _studentSizeMaxController.text.trim();
                        } else {
                          _resultsFilters['studentSizeMax'] = '';
                        }
                        if (_gradStudentsMinController.text.trim().isNotEmpty) {
                          _resultsFilters['gradStudentsMin'] =
                              _gradStudentsMinController.text.trim();
                        } else {
                          _resultsFilters['gradStudentsMin'] = '';
                        }
                        if (_gradStudentsMaxController.text.trim().isNotEmpty) {
                          _resultsFilters['gradStudentsMax'] =
                              _gradStudentsMaxController.text.trim();
                        } else {
                          _resultsFilters['gradStudentsMax'] = '';
                        }
                        if (_inStateTuitionMaxController.text
                            .trim()
                            .isNotEmpty) {
                          _resultsFilters['inStateTuitionMax'] =
                              _inStateTuitionMaxController.text.trim();
                        } else {
                          _resultsFilters['inStateTuitionMax'] = '';
                        }
                        if (_outOfStateTuitionMaxController.text
                            .trim()
                            .isNotEmpty) {
                          _resultsFilters['outOfStateTuitionMax'] =
                              _outOfStateTuitionMaxController.text.trim();
                        } else {
                          _resultsFilters['outOfStateTuitionMax'] = '';
                        }
                        setState(() {
                          filtersApplied = true;
                        });
                      }
                    : null,
                child: const Text(
                  'Apply Filters',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding showDoc(int index, List<Result> results) {
    List<CipProgram>? cipPrograms = [];
    if (results[index].cipPrograms != null) {
      cipPrograms = results[index].cipPrograms;
    } else {
      cipPrograms = [];
    }

    String? schoolName = '';
    schoolName = results[index].schoolName;

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (index == 0)
              ? const SizedBox(height: 0.0)
              : const SizedBox(height: 8.0),
          Text(
            'School #${index + schoolCountBase}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 2.0),
          Row(
            children: [
              const Text('Name:'),
              const SizedBox(width: 6),
              Expanded(child: Text(results[index].schoolName)),
            ],
          ),
          Row(
            children: [
              const Text('City:'),
              const SizedBox(width: 6),
              Expanded(child: Text(results[index].schoolCity)),
            ],
          ),
          Row(
            children: [
              const Text('State:'),
              const SizedBox(width: 6),
              Expanded(child: Text(results[index].schoolState)),
            ],
          ),
          Row(
            children: [
              const Text('School URL:'),
              const SizedBox(width: 6),
              Expanded(child: Text(results[index].schoolSchoolUrl)),
            ],
          ),
          Row(
            children: [
              if (results[index].schoolSchoolUrl.isNotEmpty &&
                  results[index].schoolSchoolUrl.startsWith('http'))
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Uri url = Uri.parse(results[index].schoolSchoolUrl);
                      launchThisUrl(url);
                    },
                    child: const Text('Visit web page for school URL'),
                  ),
                )
              else if (results[index].schoolSchoolUrl.isNotEmpty &&
                  !results[index].schoolSchoolUrl.startsWith('http'))
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Uri url =
                          Uri.parse('http://${results[index].schoolSchoolUrl}');
                      launchThisUrl(url);
                    },
                    child: const Text(
                        'Visit web page for school URL (with http:// added)'),
                  ),
                )
              else
                const Expanded(
                  child: ElevatedButton(
                    onPressed: null,
                    child:
                        Text('Visit web page for school price calculator URL'),
                  ),
                )
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              const Text('School Price Calculator URL:'),
              const SizedBox(width: 6),
              Expanded(
                  child: Text(results[index].schoolSchoolPriceCalculatorUrl)),
            ],
          ),
          Row(
            children: [
              if (results[index].schoolSchoolPriceCalculatorUrl.isNotEmpty &&
                  results[index]
                      .schoolSchoolPriceCalculatorUrl
                      .startsWith('http'))
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Uri url = Uri.parse(
                          results[index].schoolSchoolPriceCalculatorUrl);
                      launchThisUrl(url);
                    },
                    child: const Text(
                        'Visit web page for school price calculator URL'),
                  ),
                )
              else if (results[index]
                      .schoolSchoolPriceCalculatorUrl
                      .isNotEmpty &&
                  !results[index]
                      .schoolSchoolPriceCalculatorUrl
                      .startsWith('http'))
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Uri url = Uri.parse(
                          'http://${results[index].schoolSchoolPriceCalculatorUrl}');
                      launchThisUrl(url);
                    },
                    child: const Text(
                        'Visit web page for school price calculator URL (with http:// added)'),
                  ),
                )
              else
                const Expanded(
                  child: ElevatedButton(
                    onPressed: null,
                    child:
                        Text('Visit web page for school price calculator URL'),
                  ),
                )
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              const Text('Student Size:'),
              const SizedBox(width: 6),
              Expanded(
                child: results[index].studentSize > 0
                    ? Text(results[index].studentSize.toString())
                    : Text(
                        '${results[index].studentSize.toString()} (or unkown)'),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Graduate Student Size:'),
              const SizedBox(width: 6),
              Expanded(
                child: results[index].studentGradStudents > 0
                    ? Text(results[index].studentGradStudents.toString())
                    : Text(
                        '${results[index].studentGradStudents.toString()} (or unkown)'),
              ),
            ],
          ),
          Row(
            children: [
              const Text('In State Tuition:'),
              const SizedBox(width: 6),
              Expanded(
                child: results[index].costTuitionInState > 0
                    ? Text(results[index].costTuitionInState.toString())
                    : Text(
                        '${results[index].costTuitionInState.toString()} (or unkown)'),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Out of State Tuition:'),
              const SizedBox(width: 6),
              Expanded(
                child: results[index].costTuitionOutOfState > 0
                    ? Text(results[index].costTuitionOutOfState.toString())
                    : Text(
                        '${results[index].costTuitionOutOfState.toString()} (or unkown)'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: cipPrograms!.isNotEmpty &&
                          !_searchValues!
                              .containsKey('latest.programs.cip_4_digit.code')
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProgramsListPage(
                                cipPrograms: cipPrograms!,
                                schoolName: schoolName!,
                              ),
                            ),
                          );
                        }
                      : null,
                  child: const Text('Show programs list for this school'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
