import 'package:flutter/cupertino.dart';
import 'package:habit_tracker_apriyan/models/app_settings.dart';
import 'package:habit_tracker_apriyan/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  /*

  S E T U P

  */

  // I N I T I A L I Z E - D A T A B A S E
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  // Save First Date of App Startup (for Heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(
        () => isar.appSettings.put(settings),
      );
    }
  }

  // Get First Date of App
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /*

  C R U D X O P E R A T I O N S

  */

  // List of Habits
  final List<Habit> currentHabits = [];

  // C R E A T E - Add a New Habit
  Future<void> addHabit(String habitName) async {
    // Create a New Habit
    final newHabit = Habit()..name = habitName;

    // Save to Database
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // re-Read from Database
    readHabits();
  }

  // R E A D - Read Saved Habits from Database
  Future<void> readHabits() async {
    // Fetch All Habits from Database
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    // Give to Current Habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // Update UI
    notifyListeners();
  }

  // U P D A T E - Check Habit On and Off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // Find Specific Habit
    final habit = await isar.habits.get(id);

    // Update Completion Status
    if (habit != null) {
      await isar.writeTxn(() async {
        // If Habit is Completed -> Add the Current Date to the completedDays List
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          // Today
          final today = DateTime.now();

          // Add the Current Date If It's not already in the List
          habit.completedDays.add(
            DateTime(
              today.year,
              today.month,
              today.day,
            ),
          );
        }

        // If Habis is NOT Completed -> Remove the Current Date from the List
        else {
          // Remove the Current Date if the Habit is Marked as not Completed
          habit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        // Save the Updated Habits back to the Database
        await isar.habits.put(habit);
      });
    }

    // re-Read from Database
    readHabits();
  }

  // U P D A T E - Edit Habit Name
  Future<void> updateHabitName(int id, String newName) async {
    // Find the Specific Habit
    final habit = await isar.habits.get(id);
    // Update Habit Name
    if (habit != null) {
      // Update Name
      await isar.writeTxn(() async {
        habit.name = newName;
        // Save Updated Habit Back to the Database
        await isar.habits.put(habit);
      });
    }

    // re-Read from Database
    readHabits();
  }

  // D E L E T E - Delete Habit
  Future<void> deleteHabit(int id) async {
    // Perform the Delete
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
  }
}
