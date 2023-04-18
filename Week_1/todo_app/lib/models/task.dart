import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;
  @HiveField(2)
  String date;
  @HiveField(3)
  String time;
  @HiveField(4)
  int status; // 0 - Incomplete, 1 - Complete

  Task(
      {required this.title,
      required this.description,
      required this.date,
      required this.time,
      required this.status});
}
