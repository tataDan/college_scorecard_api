import 'package:flutter/material.dart';

import '../models/college_scorecard.dart';

class ProgramsListPage extends StatelessWidget {
  final List<CipProgram> cipPrograms;
  final String schoolName;
  const ProgramsListPage({
    required this.cipPrograms,
    required this.schoolName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Programs List for $schoolName')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          shrinkWrap: true,
          primary: true,
          padding: const EdgeInsets.only(top: 10),
          itemCount: cipPrograms.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Text(cipPrograms[index].code),
                const SizedBox(width: 10.0),
                Expanded(child: Text(cipPrograms[index].title)),
              ],
            );
          },
        ),
      ),
    );
  }
}
