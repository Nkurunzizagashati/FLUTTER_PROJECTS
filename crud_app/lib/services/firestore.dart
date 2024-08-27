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

  Stream<QuerySnapshot> getNotesStream() {
    final streamNotes =
        notes.orderBy('timestamp', descending: true).snapshots();

    return streamNotes;
  }
  // UPDATE: update notes in db given a note id

  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }
  // DELETE: delete notes from db given a note id

  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
