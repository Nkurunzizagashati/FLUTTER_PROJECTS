import 'package:flutter/material.dart';
import 'package:simple_socialmedia_app/services/auth_servces.dart';
import 'package:simple_socialmedia_app/services/notification.dart';
import 'package:simple_socialmedia_app/services/task_services.dart';

final authServices = AuthServices();
final taskServices = TaskServices();

void createTask(
  BuildContext context, // Add context here
  TextEditingController taskNameController,
  TextEditingController taskDescriptionController,
  String? selectedUser,
  TextEditingController startTimeController,
  TextEditingController deadlineController,
) async {
  final currentUserEmail = await authServices.getCurrentUserEmail();

  if (currentUserEmail != null) {
    final taskName = taskNameController.text.trim();
    final taskDescription = taskDescriptionController.text.trim();
    final assignedTo = selectedUser;
    final startDate = DateTime.tryParse(startTimeController.text.trim());
    final endDate = DateTime.tryParse(deadlineController.text.trim());

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
      try {
        await taskServices.createTask(
          taskName,
          taskDescription,
          assignedTo,
          currentUserEmail,
          startDate,
          endDate,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Task created successfully"),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to create task"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("You are not logged in"),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pushNamed(context, "/login");
  }
}
