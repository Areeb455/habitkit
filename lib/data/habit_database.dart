import 'package:habitkit/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

// reference our box
final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  // create initial default data
  void createDefaultData() {
    todaysHabitList = [
      ["Run", false],
      ["Read", false],
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

  // load data if it already exists
  void loadData() {
    // if it's a new day, get habit list from database
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");
      // set all habit completed to false since it's a new day
      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    }
    // if it's not a new day, load todays list
    else {
      todaysHabitList = _myBox.get(todaysDateFormatted());
    }
  }

  // update database
  void updateDatabase() {
    // update todays entry
    _myBox.put(todaysDateFormatted(), todaysHabitList);

    // update universal habit list in case it changed (new habit, edit habit, delete habit)
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);

    // calculate habit complete percentages for each day
    calculateHabitPercentages();

    // load heat map
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = todaysHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todaysHabitList.length).toStringAsFixed(1);

    // key: "PERCENTAGE_SUMMARY_yyyymmdd"
    // value: string of 1dp number between 0.0-1.0 inclusive
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }
void loadHeatMap() {
  // Get the current date and the first day of the current month
  DateTime firstDayOfMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  
  // Get the last day of the current month
  DateTime lastDayOfMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  // Count the number of days in the current month
  int daysInMonth = lastDayOfMonth.day;

  // Clear the previous heatmap data
  heatMapDataSet.clear();

  // Iterate over each day of the current month
  for (int i = 0; i < daysInMonth; i++) {
    DateTime currentDate = firstDayOfMonth.add(Duration(days: i));
    String yyyymmdd = convertDateTimeToString(currentDate);

    // Get the percentage value or set it to 0.0 if not available
    double strengthAsPercent = double.parse(
      _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
    );

    // Create the heatmap entry for the current date
    heatMapDataSet[currentDate] = (20 * strengthAsPercent).toInt();
  }

  // Optionally, print heatmap dataset for debugging
  print(heatMapDataSet);
}

}