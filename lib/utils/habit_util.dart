/*
  Return whether the habit is completed today
 */

import 'package:habit_tracker/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();

  return completedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

Map<DateTime, int> heatMapDataset(List<Habit> habits) {
  final Map<DateTime, int> datasets = {};

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      // Normalize the date to the start of the day
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // Increment the count for the normalized date
      datasets[normalizedDate] = (datasets[normalizedDate] ?? 0) + 1;
    }
  }

  return datasets;
}
