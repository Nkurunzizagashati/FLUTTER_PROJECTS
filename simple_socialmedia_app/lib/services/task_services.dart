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

  Stream<QuerySnapshot<Map<String, dynamic>>> getTasksStream() {
    return FirebaseFirestore.instance.collection("tasks").snapshots();
  }

  Future<void> updateTask(
      String taskID,
      String taskName,
      String taskDescription,
      String assignedTo,
      String creator,
      DateTime startDate,
      DateTime endDate) async {
    return await FirebaseFirestore.instance
        .collection("tasks")
        .doc(taskID)
        .update({
      'isCompleted': false,
      'taskName': taskName,
      'taskDescription': taskDescription,
      'assignedTo': assignedTo,
      'creator': creator,
      'startDate': startDate,
      'endDate': endDate,
    });
  }

  Future<void> updateTaskCompletionStatus(String taskID, bool isCompleted) {
    return FirebaseFirestore.instance.collection("tasks").doc(taskID).update({
      isCompleted: isCompleted,
    });
  }
}
