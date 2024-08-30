import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:simple_socialmedia_app/pages/drawer_page.dart';
import 'package:simple_socialmedia_app/pages/login_page.dart';
import 'package:simple_socialmedia_app/services/auth_servces.dart';
import 'package:simple_socialmedia_app/services/task_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void editTask(taskID) async {
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
            .updateTask(
          taskID,
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
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      style:
                          const TextStyle(color: Colors.black, fontSize: 16.0),
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
                ),
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

  void editBtnClicked(
      taskID, taskName, taskDescription, assignedTo, startDate, endDate) {
    // Initialize the controllers with the existing task values
    taskNameController.text = taskName;
    taskDescriptionController.text = taskDescription;
    startTimeController.text = startDate.toString().split(' ')[0];
    deadlineController.text = endDate.toString().split(' ')[0];

    // Initialize selected user
    selectedUser = assignedTo;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text(
            "EDIT TASK",
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
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      style:
                          const TextStyle(color: Colors.black, fontSize: 16.0),
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
                  ],
                ),
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
                backgroundColor: Theme.of(context).colorScheme.primary,
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
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: logout,
                  ),
                ],
              ),
              drawer: const DrawerPage(),
              body: FutureBuilder<String?>(
                future: AuthServices().getCurrentUserEmail(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text("Error loading user email"));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text("No user email available"));
                  } else {
                    final currentUserEmail = snapshot.data!;
                    Stream<List<DocumentSnapshot>> taskStream;

                    if (currentUserEmail == "admin@gmail.com") {
                      taskStream = FirebaseFirestore.instance
                          .collection("tasks")
                          .snapshots()
                          .map((querySnapshot) => querySnapshot.docs);
                    } else {
                      taskStream = FirebaseFirestore.instance
                          .collection("tasks")
                          .where('creator', isEqualTo: currentUserEmail)
                          .snapshots()
                          .asyncMap((creatorQuerySnapshot) async {
                        final assignedToSnapshot = await FirebaseFirestore
                            .instance
                            .collection("tasks")
                            .where('assignedTo', isEqualTo: currentUserEmail)
                            .get();
                        final allDocs = <DocumentSnapshot>{};
                        allDocs.addAll(creatorQuerySnapshot.docs);
                        allDocs.addAll(assignedToSnapshot.docs);
                        return allDocs.toList();
                      });
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder<List<DocumentSnapshot>>(
                        stream: taskStream,
                        builder: (context, taskSnapshot) {
                          if (taskSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (taskSnapshot.hasError) {
                            return const Center(
                                child: Text("Error loading tasks"));
                          } else if (!taskSnapshot.hasData ||
                              taskSnapshot.data!.isEmpty) {
                            return const Center(
                                child: Text("No tasks available"));
                          } else {
                            final tasks = taskSnapshot.data!;
                            return ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                final task =
                                    tasks[index].data() as Map<String, dynamic>;

                                // Format DateTime to String
                                final startDate =
                                    (task['startDate'] as Timestamp?)?.toDate();
                                final endDate =
                                    (task['endDate'] as Timestamp?)?.toDate();
                                final formatter = DateFormat(
                                    'yyyy-MM-dd'); // Format as needed
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          title: Center(
                                            child: Text(
                                              "${task['taskName'] ?? 'Unnamed Task'}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          subtitle: Center(
                                            child: Text(
                                              task['taskDescription'] ??
                                                  'No description',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey.shade400,
                                          thickness: 2,
                                        ),
                                        const SizedBox(height: 8.0),
                                        Wrap(
                                          spacing: 8.0, // Space between widgets
                                          runSpacing:
                                              4.0, // Space between lines
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Assigned To: ${task['assignedTo'] == currentUserEmail ? 'YOU' : task['assignedTo']}',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Creator: ${task['creator'] == currentUserEmail ? 'YOU' : task['creator']}',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Start Date: ${startDate != null ? formatter.format(startDate) : 'N/A'}',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'End Date: ${endDate != null ? formatter.format(endDate) : 'N/A'}',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                const Text('Completed'),
                                                Checkbox(
                                                  value: task['isCompleted'] ??
                                                      false,
                                                  onChanged: (bool? value) {
                                                    FirebaseFirestore.instance
                                                        .collection("tasks")
                                                        .doc(tasks[index].id)
                                                        .update(
                                                      {'isCompleted': value},
                                                    );
                                                  },
                                                  checkColor: Colors.green,
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                if (currentUserEmail ==
                                                        task['creator'] ||
                                                    currentUserEmail ==
                                                        "admin@gmail.com") {
                                                  editBtnClicked(
                                                    tasks[index].id,
                                                    task['taskName'] ??
                                                        "No task name",
                                                    task['taskDescription'] ??
                                                        "No Description",
                                                    task['assignedTo'] ?? "N/A",
                                                    startDate,
                                                    endDate,
                                                  );
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Center(
                                                          child: Text(
                                                            "Unauthorized",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        content: const Text(
                                                          "You are not allowed to perform this action.",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                              "OK",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close the dialog
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              icon: const Icon(Icons.edit),
                                              color: Colors.white,
                                              iconSize: 30,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                if (currentUserEmail ==
                                                        task['creator'] ||
                                                    currentUserEmail ==
                                                        "admin@gmail.com") {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Center(
                                                          child: Text(
                                                            "DELETE TASK?",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        content: const Text(
                                                          "Once deleted, you won't retrieve it",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        actions: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                  "CANCEL",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // Close the dialog
                                                                },
                                                              ),
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                  "DELETE",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                                onPressed: () {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "tasks")
                                                                      .doc(tasks[
                                                                              index]
                                                                          .id)
                                                                      .delete();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Center(
                                                          child: Text(
                                                            "Unauthorized",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        content: const Text(
                                                          "You are not allowed to perform this action.",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                              "OK",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close the dialog
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              icon: const Icon(Icons.delete),
                                              color: Colors.red.shade900,
                                              iconSize: 30,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    );
                  }
                },
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
