import 'package:piper_team_tasks/models/task.dart';
import 'package:piper_team_tasks/widgets/quranInfo.dart';

class GenerateAssignments {


  List<Task> generateMultipleAssignments(
      DateTime fromDate, DateTime toDate, int from, int to) {

    int duration = toDate.difference(fromDate).inDays;

    List initialSurah = QuranHelper().juzInfo[from]; //[4, 148]
    List finalSurah = QuranHelper().juzInfo[to + 1]; //[11, 6]

    int cumVerse1 = (QuranHelper().surahInfo[initialSurah[0]][0] as int) +
        initialSurah[1]; // 493 + 148
    int cumVerse2 = (QuranHelper().surahInfo[finalSurah[0]][0] as int) +
        (finalSurah[1] - 1); //1473 + (6-1)

    int totalAyats = cumVerse2 - cumVerse1;

    double ayatsPerDay = totalAyats / duration;


    for (int index = 0;
        index < totalAyats;
        index = index + ayatsPerDay.round()) {}
    return null;
  }

  void generateOneAssignment() {}
}
