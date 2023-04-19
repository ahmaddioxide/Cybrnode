import 'package:flutter/material.dart';
import 'package:todo_app/models/db_helper_tasks.dart';
import 'package:todo_app/models/task.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DBHelper? dbHelper;
  late Future<List<Task>> tasks;

  Future<void> showTaskInput(context) async {
    return showDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add New Task"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: "Enter Task Title",
                        labelText: "Task Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: "Enter Task Description",
                      labelText: "Task Description",
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close))),
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () {
                        addTask();
                        Get.back();
                      },
                      icon: const Icon(Icons.add))),
            ],
          );
        });
  }

  addTask() {
    var task = Task(
      title: titleController.text,
      description: descriptionController.text,
      date:
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      time: "${DateTime.now().hour}:${DateTime.now().minute}",
      status: 0,
    );

    dbHelper!.insert(task);
    tasks = dbHelper!.getTasks();
    titleController.clear();
    descriptionController.clear();
    print("Task Added Successfully");
  }
}
