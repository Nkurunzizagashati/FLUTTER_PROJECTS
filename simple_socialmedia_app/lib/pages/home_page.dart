import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_socialmedia_app/pages/login_page.dart';
import 'package:simple_socialmedia_app/services/auth_servces.dart';
import 'package:simple_socialmedia_app/widgets/text_field.dart';

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

  void logout() {
    FirebaseAuth.instance.signOut();
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
        title: const Text("CREATE TASK"),
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
                  CustomTextField(
                    hintText: "task name",
                    obsecureText: false,
                    controller: taskNameController,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: "task description",
                    obsecureText: false,
                    controller: taskDescriptionController,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled:
                          true, // This makes sure the dropdown background is filled
                      fillColor: Colors
                          .white, // Set a background color to make it stand out
                      border: OutlineInputBorder(
                        // Add a border to the dropdown
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal:
                              10.0), // Adjust the padding for better spacing
                    ),
                    value: selectedUser,
                    hint: const Text(
                      'Assign To',
                      style: TextStyle(color: Colors.black),
                    ),
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Colors.black), // Change the dropdown icon color
                    items: usersList.map((String user) {
                      return DropdownMenuItem<String>(
                        value: user,
                        child: Text(
                          user,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize:
                                  16.0), // Adjust the text color and size for visibility
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedUser = newValue;
                      });
                    },
                    dropdownColor:
                        Colors.white, // Set the dropdown menu background color
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0), // Set the text style for selected item
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
                        // Add a border to the dropdown
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal:
                              10.0), // Adjust the padding for better spacing
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
                        // Add a border to the dropdown
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal:
                              10.0), // Adjust the padding for better spacing
                    ),
                  ),
                ],
              );
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
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
