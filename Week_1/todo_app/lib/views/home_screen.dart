import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/db_helper_tasks.dart';
import 'package:todo_app/models/task.dart';
import '../controllers/task_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    taskController.dbHelper = DBHelper();
    taskController.tasks = taskController.dbHelper!.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App",
            style: TextStyle(
              color: Colors.purple,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            )),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await taskController.showTaskInput(context);
        },
        label: const Text("Add New Task"),
        icon: const Icon(Icons.task),
      ),
      body: FutureBuilder(
          future: taskController.tasks,
          builder: (context, AsyncSnapshot<List<Task>> snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No Tasks"),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error"),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    int todoId = snapshot.data![index].id!.toInt();
                    String todoTitle = snapshot.data![index].title!.toString();
                    String todoDescription =
                        snapshot.data![index].description!.toString();
                    String todoDate = snapshot.data![index].date!.toString();
                    String todoTime = snapshot.data![index].time!.toString();

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Dismissible(
                        key: ValueKey<int>(todoId),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (DismissDirection direction) {
                          // taskController.dbHelper!.delete(todoId);
                          setState(() {
                            DBHelper().delete(todoId);
                            taskController.tasks =
                                taskController.dbHelper!.getTasks();
                            snapshot.data!.removeAt(index);
                          });
                        },
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Icon(Icons.delete_forever_rounded,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        child: Container(
                            // margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade300,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 4,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            // margin: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                ListTile(
                                  // contentPadding: EdgeInsets.all(10),
                                  title: Text(
                                    todoTitle,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      todoDescription,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white70),
                                    ),
                                  ),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.purple,
                                        size: 25,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                  onTap: () {
                                    // taskController.showTaskInput(context);
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 0.8,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 3,
                                    horizontal: 10,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          todoTime,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          todoDate,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
    // ignore: empty_statements
  }
}
