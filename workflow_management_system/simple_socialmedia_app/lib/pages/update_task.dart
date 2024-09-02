import 'package:cloud_firestore/cloud_firestore.dart';
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
  late TextEditingController taskNameController = TextEditingController();
  late TextEditingController taskDescriptionController =
      TextEditingController();
  late TextEditingController deadlineController = TextEditingController();
  late TextEditingController startTimeController = TextEditingController();

  String? selectedUser; // Make this nullable
  final Future<List<String>> users = AuthServices().getAllUsers();
  final authServices = AuthServices();
  final taskServices = TaskServices();
  final currentUserEmail = AuthServices().getCurrentUserEmail();

  @override
  void initState() {
    super.initState();
    taskNameController = TextEditingController();
    taskDescriptionController = TextEditingController();
    startTimeController = TextEditingController();
    deadlineController = TextEditingController();
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
      barrierColor:
          Colors.black.withOpacity(0.5), // Customize the barrier color
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade300, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Text color of the days
            ),
            dialogBackgroundColor:
                Colors.white, // Background color of the dialog
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Button text color
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        deadlineController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      barrierColor:
          Colors.black.withOpacity(0.5), // Customize the barrier color
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade300, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Text color of the days
            ),
            dialogBackgroundColor:
                Colors.white, // Background color of the dialog
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ) // Button text color
                  ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        startTimeController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void editTask(taskID) {}

  @override
  Widget build(BuildContext context) {
    final String taskID = ModalRoute.of(context)!.settings.arguments as String;

    // final usersList = authServices.getAllUsers() ?? [];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("UPDATE TASK"),
      ),
      body: FutureBuilder<List<String>>(
        future: authServices.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text("Error loading users");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("No users found");
          } else {
            final List<String> usersList = snapshot.data!;

            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: taskServices.getTaskStream(taskID),
              builder: (context, taskSnapshot) {
                if (taskSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (taskSnapshot.hasError) {
                  return const Text("Error loading task");
                } else {
                  final taskData = taskSnapshot.data!.data()!;
                  taskNameController.text = taskData['taskName'];
                  taskDescriptionController.text = taskData['taskDescription'];
                  startTimeController.text = DateFormat('yyyy-MM-dd')
                      .format((taskData['startDate'] as Timestamp).toDate());

                  deadlineController.text = DateFormat('yyyy-MM-dd')
                      .format((taskData['endDate'] as Timestamp).toDate());

                  selectedUser = taskData['assignedTo'];

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 25),
                        TextField(
                          controller: taskNameController,
                          obscureText: false,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "Task Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          style: const TextStyle(color: Colors.black),
                          controller: taskDescriptionController,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: "Task Description",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                          ),
                          value: selectedUser,
                          hint: const Text(
                            'Assign To',
                            style: TextStyle(color: Colors.black),
                          ),
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Colors.black),
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
                          dropdownColor: Colors.white,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16.0),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: startTimeController,
                          readOnly: true,
                          onTap: () => _selectStartTime(context),
                          decoration: InputDecoration(
                            hintText: "Start Date",
                            suffixIcon: const Icon(Icons.calendar_today),
                            filled: true,
                            fillColor: Colors.blue.shade300,
                            hintStyle: const TextStyle(color: Colors.black),
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
                            hintText: "End Date",
                            suffixIcon: const Icon(Icons.calendar_today),
                            filled: true,
                            fillColor: Colors.blue.shade300,
                            hintStyle: const TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                editTask(taskID); // Call the editTask function
                                Navigator.pop(context); // Close the dialog
                              },
                              child: const Text(
                                "Edit",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
