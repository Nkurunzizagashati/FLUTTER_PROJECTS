import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Task Name',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Task Name',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Task Name',
            ),
          ),
        ],
      ),
    );
  }
}
