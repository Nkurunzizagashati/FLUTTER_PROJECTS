import 'package:flutter/material.dart';
import 'package:simple_socialmedia_app/services/auth_servces.dart';
import 'package:simple_socialmedia_app/services/task_services.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("CREATE TASK"),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: FutureBuilder<List<String>>(
          future: users,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text("Error loading users");
            } else {
              final usersList = snapshot.data ?? [];
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
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
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
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
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
                              // createTask(); // Call the createTask function
                              Navigator.pop(context); // Close the dialog
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
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
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
      ),
    );
  }
}
