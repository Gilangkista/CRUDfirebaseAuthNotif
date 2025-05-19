import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/note_model.dart';
import 'services/firestore_service.dart';
import 'services/notification_service.dart';
import 'note_form_page.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();
  final user = FirebaseAuth.instance.currentUser;

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(child: Text("User not logged in"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Note>>(
        stream: _firestoreService.getNotes(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text("Error");
          if (!snapshot.hasData) return const CircularProgressIndicator();

          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await _firestoreService.deleteNote(note.id!);
                    NotificationService.showNotification(
                      'Note Dihapus',
                      '"${note.title}" berhasil dihapus.',
                    );
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NoteFormPage(note: note)),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NoteFormPage()),
          );
        },
      ),
    );
  }
}
