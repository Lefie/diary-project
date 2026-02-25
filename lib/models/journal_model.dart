
import 'package:cloud_firestore/cloud_firestore.dart';

class JournalModel {

  final String content;
  final String mood;
  final String? journal_id;
  final DateTime created_at;
  final String user_id;

  const JournalModel({
    required this.content,
    required this.mood,
    required this.created_at,
    required this.user_id,
    this.journal_id,
  });

  Map<String, dynamic> toJson() {

    return {
      "content": content,
      "mood":mood,
      "created_at": created_at,
      "user_id": user_id,
    };
  }

  factory JournalModel.fromJson(Map<String, dynamic> json, String doc_id) {
    print("from inside the function $json, $doc_id");
    return JournalModel(
        content: json["content"],
        mood : json["mood"],
        created_at:json["created_at"] is Timestamp
            ? (json["created_at"] as Timestamp).toDate()
            : json["created_at"] as DateTime,
        journal_id: doc_id,
        user_id: json["user_id"]
    );
  }

}