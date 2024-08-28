import 'package:flutter/material.dart';
import 'package:test_app/services/auth_services.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  List<Map<String, String>> _users = [];
  String? _assignedTo;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    // Call the fetchUsers method from AuthServices
    final AuthServices authServices = AuthServices();
    final usersFromDb = await authServices.fetchUsers();
    print(usersFromDb);

    setState(() {
      _users = usersFromDb;
    });
  }

  Future<void> fetchUsersFromDb() async {
    final authServices = AuthServices();
    final users2 = await authServices.fetchUsers();
    print(users2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 75),
                const Text(
                  "CREATE TASK",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Fill in the details to create a new task",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 50),

                // Task Name Field
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(14)),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Task name",
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Description Field
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(14)),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Description",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Dropdown to Select Creator
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: DropdownButton<String>(
                      value: _assignedTo,
                      hint: const Text("Assign task to"),
                      onChanged: (String? newValue) {
                        setState(() {
                          _assignedTo = newValue;
                        });
                      },
                      items: _users.map<DropdownMenuItem<String>>((user) {
                        return DropdownMenuItem<String>(
                          value: user["name"],
                          child: Text(user["name"]!),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Create Task Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(14)),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          // Handle task creation logic
                          print("Task assigned To $_assignedTo");
                        },
                        child: const Text(
                          "CREATE TASK",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                ElevatedButton(
                    onPressed: fetchUsersFromDb, child: Text("Fetch users"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
