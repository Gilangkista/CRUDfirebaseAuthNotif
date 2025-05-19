import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class FirestoreService {
  final CollectionReference _notes = FirebaseFirestore.instance.collection(
    'notes',
  );

  Stream<List<Note>> getNotes(String uid) {
    return _notes.where('uid', isEqualTo: uid).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Note.fromMap(data, doc.id);
      }).toList();
    });
  }

  Future<void> addNote(String uid, Note note) async {
    await _notes.add({...note.toMap(), 'uid': uid});
  }

  Future<void> updateNote(Note note) async {
    await _notes.doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String id) async {
    await _notes.doc(id).delete();
  }
}
