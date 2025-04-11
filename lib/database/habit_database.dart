import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // Initialize the Isar DB
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
    ], directory: dir.path);
  }

  // Save the Launch Date
  Future<void> saveLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Get the Launch Date
  Future<DateTime?> getLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /* CRUD OPERATIONS */

  final List<Habit> habits = [];

  // Create a Habit
  Future<void> createHabit(String name) async {
    final newHabit = Habit()..habitName = name;

    await isar.writeTxn(() => isar.habits.put(newHabit));
    readHabits();
  }

  // Read all habits from the db
  Future<void> readHabits() async {
    final allHabits = await isar.habits.where().findAll();

    // Add fetched habits to the list
    habits.clear();
    habits.addAll(allHabits);

    notifyListeners();
  }

  // Toggle habit completion
  Future<void> toggleHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);
    final today = DateTime.now();

    if (habit != null) {
      await isar.writeTxn(() async {
        if (isCompleted && !habit.completedDays.contains(today)) {
          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        } else {
          habit.completedDays.removeWhere(
            (date) =>
                date.year == today.year &&
                date.month == today.month &&
                date.day == today.day,
          );
        }

        await isar.habits.put(habit);
      });
    }

    readHabits();
  }

  // Edit a Habit
  Future<void> editHabit(int id, String newName) async {
    final habit = await isar.habits.get(id);

    if (habit != null) {
      habit.habitName = newName;
      await isar.writeTxn(() => isar.habits.put(habit));
    }

    readHabits();
  }

  // Delete a Habit
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() => isar.habits.delete(id));
    readHabits();
  }
}
