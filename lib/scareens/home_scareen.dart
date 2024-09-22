import 'package:flutter/material.dart';
import 'package:to_do_list/models/task_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<TaskModel> tasks = [];
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext constext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Abdalrhman"),
        bottom: TabBar(controller: _tabController, tabs: [
          Tab(
            text: 'All Tasks',
          ),
          Tab(
            text: 'Completed Tasks',
          ),
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(false),
          _buildTaskList(true),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String newTaskTitle = ""; // Initialize to empty string
          String? newTaskDescription; // Optional description, nullable

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Enter Task Name',
                    ),
                    onChanged: (value) {
                      // Store the entered task name
                      newTaskTitle = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Description (Optional)',
                    ),
                    onChanged: (value) {
                      // Store the entered description (optional)
                      newTaskDescription = value;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      tasks.add(TaskModel(
                        title: newTaskTitle ?? "", // Use ?? for null safety
                        subtitle: newTaskDescription,
                        createdAt: DateTime.now(),
                      ));
                    });
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(bool isCompleted) {
    List<TaskModel> filteredTasks =
        tasks.where((task) => task.isCompleted == isCompleted).toList();
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index]; // Use filteredTasks directly
        return Card(
          child: ListTile(
            tileColor: const Color.fromARGB(255, 18, 221, 45).withOpacity(0.1),
            title: Text(task.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.subtitle != null) Text(task.subtitle!),
                Text(
                  ' : ${task.createdAt}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            trailing: Checkbox(
              value: task.isCompleted,
              onChanged: (check) => setState(() => task.isCompleted = check!),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 16.0),
    );
  }

  void main() => runApp(MaterialApp(home: HomeScreen()));
}
