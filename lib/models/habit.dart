import 'package:isar/isar.dart';

// Run dart run build_runner build

part 'habit.g.dart';

@Collection()
class Habit {
  Id id = Isar.autoIncrement;
  late String habitName;
  List<DateTime> completedDays = [

  ];
}