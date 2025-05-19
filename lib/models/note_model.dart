class Note {
  String? id;
  String title;
  String content;

  Note({this.id, required this.title, required this.content});

  factory Note.fromMap(Map<String, dynamic> data, String documentId) {
    return Note(
      id: documentId,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'content': content};
  }
}
