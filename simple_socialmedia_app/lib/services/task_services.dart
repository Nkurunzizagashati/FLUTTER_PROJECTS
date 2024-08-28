import 'package:cloud_firestore/cloud_firestore.dart';

class TaskServices {
  Future<DocumentReference<Map<String, dynamic>>> createTask(
      String taskName,
      String taskDescription,
      String assignedTo,
      String creator,
      DateTime startDate,
      DateTime endDate) async {
    return await FirebaseFirestore.instance.collection("tasks").add({
      'taskName': taskName,
      'taskDescription': taskDescription,
      'assignedTo': assignedTo,
      'creator': creator,
      'startDate': startDate,
      'endDate': endDate,
    });
  }
}
