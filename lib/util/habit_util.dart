// Given a Habit List of Completion Days
// is the Habit Completed Today
import '../models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

// Prepare Heat Map Datasets
Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      // Normalize Date to Avoid Time Missmatch
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // If the Date already exist in the dataset, increment its count
      if (dataset.containsKey(normalizedDate)) {
        dataset[normalizedDate] = dataset[normalizedDate]! + 1;
      } else {
        // else initialize it with a count of 1
        dataset[normalizedDate] = 1;
      }
    }
  }

  return dataset;
}
