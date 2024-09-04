import 'package:cloud_firestore/cloud_firestore.dart';

class TaskServices {
  Future<DocumentReference<Map<String, dynamic>>> createTask(
      String taskName,
      String taskDescription,
      String assignedTo,
      String creator,
      DateTime startDate,
      DateTime endDate) async {
    final createdTask =
        await FirebaseFirestore.instance.collection("tasks").add({
      'taskName': taskName,
      'taskDescription': taskDescription,
      'assignedTo': assignedTo,
      'creator': creator,
      'startDate': startDate,
      'endDate': endDate,
    });

    await FirebaseFirestore.instance.collection("notifications").add({
      'title': "A new task has been created for you",
      'receiverEmail': assignedTo,
      'senderEmail': creator,
      'isRead': false,
      'taskID': createdTask.id,
    });

    return createdTask;
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

  Stream<DocumentSnapshot<Map<String, dynamic>>> getTaskStream(taskID) {
    return FirebaseFirestore.instance
        .collection("tasks")
        .doc(taskID)
        .snapshots();
  }
}
