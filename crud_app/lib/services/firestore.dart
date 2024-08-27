import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection of notes

  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");

  // CREATE: add notes to db

  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }
  // READ: fetch notes from db
  // UPDATE: update notes in db given a note id
  // DELETE: delete notes from db given a note id
}
