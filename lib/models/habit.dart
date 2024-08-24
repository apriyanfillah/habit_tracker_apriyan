import 'package:isar/isar.dart';

// Run CMD to Generate File: dart run build_runner build
part 'habit.g.dart';

@Collection()
class Habit {
  // Habit Id
  Id id = Isar.autoIncrement;

  // Habit Name
  late String name;

  // Completed Days
  List<DateTime> completedDays = [
    // DateTime(year, month, day),
    // DateTime(2024, 8, 1),
    // DateTime(2024, 8, 1),
  ];
}
