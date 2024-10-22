import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/search_values/search_values_cubit.dart';
import '../utilities/url_launcher.dart';
import 'documents_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _programCodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _programCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('College API')),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const SizedBox(height: 6),
          searchEntriesColumn(),
          buttonRow(),
        ],
      ),
    );
  }

  void clearSearchEntries() {
    _nameController.text = '';
    _cityController.text = '';
    _stateController.text = '';
    _programCodeController.text = '';
  }

  Future<void> _showEmptyFieldsDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Empty Fields'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please enter text into at least one search field.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Padding searchEntriesColumn() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 250.0,
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              SizedBox(
                width: 200.0,
                child: TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'Enter city',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Uri url = Uri.parse(
                        'https://www.bls.gov/respondents/mwr/electronic-data-interchange/appendix-d-usps-state-abbreviations-and-fips-codes.htm');
                    launchThisUrl(url);
                  },
                  child: const Text(
                      'Visit web page for 2-letter state codes (e.g. NM)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              SizedBox(
                width: 120.0,
                child: TextField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'Enter state',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Uri url = Uri.parse(
                        'https://nces.ed.gov/ipeds/cipcode/browse.aspx?y=56');
                    launchThisUrl(url);
                  },
                  child: const Text(
                      'Visit web page for 4-digit program codes (e.g. 0301)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              SizedBox(
                width: 200.0,
                child: TextField(
                  controller: _programCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Enter a program code',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Padding buttonRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.trim().isEmpty &&
                  _cityController.text.trim().isEmpty &&
                  _stateController.text.trim().isEmpty &&
                  _programCodeController.text.trim().isEmpty) {
                _showEmptyFieldsDialog();
                return;
              }
              Map<String, String> searchValues = {};
              if (_nameController.text.trim().isNotEmpty) {
                searchValues['latest.school.name'] =
                    _nameController.text.trim();
              }
              if (_cityController.text.trim().isNotEmpty) {
                searchValues['latest.school.city'] =
                    _cityController.text.trim();
              }
              if (_stateController.text.trim().isNotEmpty) {
                searchValues['latest.school.state'] =
                    _stateController.text.trim();
              }
              if (_programCodeController.text.trim().isNotEmpty) {
                searchValues['latest.programs.cip_4_digit.code'] =
                    _programCodeController.text.trim();
              }

              SearchValuesCubit searchValuesCubit =
                  context.read<SearchValuesCubit>();
              Map<String, String> newSearchValues = searchValues;

              searchValuesCubit.updateSearchValues(newSearchValues);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DocumentsPage(),
                ),
              );
            },
            child: const Text('Get school data'),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: ElevatedButton(
              onPressed: clearSearchEntries,
              child: const Text('Clear search entries'),
            ),
          ),
        ],
      ),
    );
  }
}
