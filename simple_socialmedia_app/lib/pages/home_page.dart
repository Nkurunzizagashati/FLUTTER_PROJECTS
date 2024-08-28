import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_socialmedia_app/pages/login_page.dart';
import 'package:simple_socialmedia_app/services/auth_servces.dart';
import 'package:simple_socialmedia_app/services/task_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();
  final TextEditingController assignedToController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  String? selectedUser; // Make this nullable
  final Future<List<String>> users = AuthServices().getAllUsers();
  final authServices = AuthServices();
  final taskServices = TaskServices();

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  void createTask() async {
    final currentUserEmail = await authServices.getCurrentUserEmail();

    if (currentUserEmail != null) {
      final taskName = taskNameController.text.trim();
      final taskDescription = taskDescriptionController.text.trim();
      final assignedTo = selectedUser;
      final startDate = DateTime.parse(startTimeController.text.trim());
      final endDate = DateTime.parse(deadlineController.text.trim());

      if (taskName.isEmpty ||
          taskDescription.isEmpty ||
          assignedTo == null ||
          startDate == null ||
          endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("All fields are required"),
            duration: Duration(seconds: 1),
          ),
        );
        return;
      } else {
        taskServices
            .createTask(
          taskName,
          taskDescription,
          assignedTo,
          currentUserEmail,
          startDate,
          endDate,
        )
            .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                child: Text(
                  "Task created successfully!",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              showCloseIcon: true,
            ),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text(
                  "Failed to create task: $error",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              showCloseIcon: true,
            ),
          );
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text(
              "You are not logged in",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
        ),
      );

      Navigator.pushNamed(context, "/login");
    }
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
    );
    if (picked != null) {
      setState(() {
        startTimeController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void createTaskBtnClicked() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text(
            "CREATE TASK",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        alignment: Alignment.center,
        content: FutureBuilder<List<String>>(
          future: users,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text("Error loading users");
            } else {
              final usersList = snapshot.data ?? [];
              return Column(
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
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
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
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
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
                    style: const TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: startTimeController,
                    readOnly: true,
                    onTap: () => _selectStartTime(context),
                    decoration: InputDecoration(
                      hintText: "start date",
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
                      hintText: "end date",
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
                ],
              );
            }
          },
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  createTask(); // Call the createTask function
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text(
                  "Create",
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: AppBar(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.surface,
                title: const Text(
                  'View Tasks',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: logout,
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: logout,
                  ),
                ],
              ),
              body: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: createTaskBtnClicked,
                child: const Icon(Icons.add),
              ),
            );
          } else {
            return const LoginPage();
          }
        });
  }
}
