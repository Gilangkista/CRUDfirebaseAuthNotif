import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/note_model.dart';
import 'services/firestore_service.dart';
import 'services/notification_service.dart';

class NoteFormPage extends StatefulWidget {
  final Note? note;

  const NoteFormPage({super.key, this.note});

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final _firestoreService = FirestoreService();
  final _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Tambah Catatan' : 'Edit Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Isi'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Simpan'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final note = Note(
                      id: widget.note?.id,
                      title: _titleController.text,
                      content: _contentController.text,
                    );
                    if (widget.note == null) {
                      await _firestoreService.addNote(_user!.uid, note);
                      NotificationService.showNotification(
                        'Note Ditambahkan',
                        '"${note.title}" berhasil disimpan.',
                      );
                    } else {
                      await _firestoreService.updateNote(note);
                      NotificationService.showNotification(
                        'Note Diperbarui',
                        '"${note.title}" berhasil diperbarui.',
                      );
                    }
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
