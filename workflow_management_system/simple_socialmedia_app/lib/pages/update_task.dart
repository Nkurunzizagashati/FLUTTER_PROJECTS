import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_socialmedia_app/services/auth_servces.dart';
import 'package:simple_socialmedia_app/services/task_services.dart';

class UpdateTask extends StatefulWidget {
  const UpdateTask({super.key});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  late TextEditingController taskNameController;
  late TextEditingController taskDescriptionController;
  late TextEditingController deadlineController;
  late TextEditingController startTimeController;

  String? selectedUser;
  String? currentUserEmail;
  final authServices = AuthServices();
  final taskServices = TaskServices();

  @override
  void initState() {
    super.initState();
    taskNameController = TextEditingController();
    taskDescriptionController = TextEditingController();
    startTimeController = TextEditingController();
    deadlineController = TextEditingController();
    _initializeCurrentUserEmail();
  }

  Future<void> _initializeCurrentUserEmail() async {
    currentUserEmail = await authServices.getCurrentUserEmail();
    setState(() {}); // To update UI after fetching currentUserEmail
  }

  @override
  void dispose() {
    taskNameController.dispose();
    taskDescriptionController.dispose();
    startTimeController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        deadlineController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        startTimeController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void editTask(String taskID) {
    // Implement your editTask logic here
    // You can use taskServices.updateTask(taskID, ...) method
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> task =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Initialize controllers once using the task data
    taskNameController.text = task['taskName'];
    taskDescriptionController.text = task['taskDescription'];
    selectedUser = task['assignedTo'];
    startTimeController.text = task['startDate'].toString();
    deadlineController.text = task['endDate'].toString();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("UPDATE TASK"),
      ),
      body: FutureBuilder<List<String>>(
        future: authServices.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading users"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No users found"));
          } else {
            final List<String> usersList = snapshot.data!;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 25),
                    TextField(
                      controller: taskNameController,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "Task Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                      controller: taskDescriptionController,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "Task Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        // fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                      ),
                      value: selectedUser,
                      hint: const Text(
                        'Assign To',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.inversePrimary),
                      items: usersList.map((String user) {
                        return DropdownMenuItem<String>(
                          value: user,
                          child: Text(
                            user,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16.0),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedUser = newValue;
                        });
                      },
                      dropdownColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 16.0),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: startTimeController,
                      readOnly: true,
                      onTap: () => _selectStartTime(context),
                      decoration: InputDecoration(
                        hintText: "start date",
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        filled: true,
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: deadlineController,
                      readOnly: true,
                      onTap: () => _selectEndTime(context),
                      decoration: InputDecoration(
                        hintText: "end date",
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        filled: true,
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            editTask(
                                task['taskID']); // Call the updateTask function
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Create",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.blue.shade300,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
