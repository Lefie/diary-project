
class Journal {

  final String content;
  final String mood;
  final String? journal_id;
  final DateTime created_at;

  const Journal({
    required this.content,
    required this.mood,
    required this.created_at,
    this.journal_id,
  });

  Map<String, dynamic> toJson() {

    return {
      "content": content,
      "mood":mood,
      "created_at": created_at
    };
  }

  factory Journal.fromJson(Map<String, dynamic> json) {
    return Journal(
        content: json["content"],
        mood : json["mood"],
        created_at: json["created_at"],
        journal_id: json["journal_id"]
    );
  }

}