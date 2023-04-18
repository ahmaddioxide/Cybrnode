import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDirectory = await getApplicationDocumentsDirectory();
  if (kDebugMode) {
    print("APP DIRECTORY :: ${appDirectory.path}");
  }
  Hive.init(appDirectory.path);
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomeScreen(),
    );
  }
}
