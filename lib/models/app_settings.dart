import 'package:isar/isar.dart';

// Run CMD to Generate File: dart run build_runner build
part 'app_settings.g.dart';

@Collection()
class AppSettings {
  Id id = Isar.autoIncrement; // Automatically incrementing ID for each record
  DateTime?
      firstLaunchDate; // Field to store the date when the app was first launched
}
