import 'package:diary/models/journal_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/stats_model.dart';


class JournalService {

  final journal_db = FirebaseFirestore.instance;

  Future<void> addData(JournalModel jour) async {

    try {
      final Map<String, dynamic> journalData = jour.toJson();
      print("journal data ${journalData}");
      DocumentReference doc = await journal_db.collection("journals").add(journalData);
      print("Document added with ID: ${doc.id}");
    }catch(e) {
      print("Error adding journal: $e");
      rethrow; // Re-throw to handle err
    }
  }


  Future<List<JournalModel>> readAllJournalEntriesByCurrentUser(String uid) async{
    print("read all journal entries called");
    QuerySnapshot<Map<String, dynamic>> res = await journal_db
        .collection("journals")
        .where('user_id',isEqualTo: uid)
        .get();


    List<JournalModel> journals = [];

    if(res.docs.isNotEmpty) {
        res.docs.forEach((doc) {
          try {
            final json = {
              "mood": doc.data()["mood"],
              "content": doc.data()["content"],
              "created_at": (doc.data()["created_at"] as Timestamp).toDate(),
              "journal_id": doc.id,
              "user_id": doc.data()["user_id"]
            };
            print("$json");
            JournalModel j = JournalModel.fromJson(json, doc.id);
            print("j is ${j}");
            journals.add(j);
          } catch (e) {
            print(e);
          }
        });
    }

    print("total num of journals ${journals.length}");

    return journals;

  }

  Future<JournalModel> readJournalById(String id, String user_id) async {
    final docRef = journal_db.collection("journals").doc(id);
    DocumentSnapshot doc = await docRef.get();
    final data = doc.data() as Map<String, dynamic>;
    final json = {
      "mood": data["mood"],
      "content": data["content"],
      "created_at": (data["created_at"] as Timestamp).toDate(),
      "journal_id": doc.id,
      "user_id": user_id
    };
    return JournalModel.fromJson(json, doc.id);

  }

  Future<void> updateJournal(String id, Map<String, dynamic> json) async {
    final journal_to_update = journal_db.collection("journals").doc(id);
    journal_to_update.update(json)
        .then((value)=>print("update success!"),
        onError: (e) => print("error updating doc ${e}"));
  }

  Future<void> deleteJournal(String id) async{
    DocumentReference<Map<String, dynamic>> journal = journal_db.collection("journals").doc(id);
    journal.delete()
        .then((doc) => print("doc deleted"),
        onError: (e) => print("error ${e}")
    );
  }

  Future<StatsModel> totalStats(String uid) async{
    final journalRef = journal_db.collection('journals')
        .where("user_id", isEqualTo: uid);

    QuerySnapshot<Map<String, dynamic>> res = await journalRef.get();

    double happy = 0.0;
    double sad = 0.0;
    double neutral = 0.0;
    double total = res.docs.length.toDouble();

    for ( var doc in res.docs) {
      final data = doc.data();
      if (data["mood"] == "happy") {
        happy ++;
      }
      if (data["mood"] == "neutral") {
        neutral ++;
      }
      if (data["mood"] == "sad") {
        sad ++;
      }
    }

    print("printing data: $happy , $sad , $neutral , $total");
    StatsModel stats = StatsModel(total_num: total, happy_num: happy, neutral_num: neutral, sad_num: sad);
    return stats;


  }

  Future< List<Map<String, dynamic>>> getStats(String uid, String week) async{

    List<Map<String, dynamic>> statsRes = [{
      "happy":0.0,
      "sad":0.0,
      "neutral":0.0,
      "total_count":0.0,
      "day":1
      },
      {
      "happy":0.0,
      "sad":0.0,
      "neutral":0.0,
      "total_count":0.0,
      "day":2
      },
      {
      "happy":0.0,
      "sad":0.0,
      "neutral":0.0,
      "total_count":0.0,
      "day":3
      },
      {
        "happy":0.0,
        "sad":0.0,
        "neutral":0.0,
        "total_count":0.0,
        "day":4
      },
      {
        "happy":0.0,
        "sad":0.0,
        "neutral":0.0,
        "total_count":0.0,
        "day":5
      },
      {
        "happy":0.0,
        "sad":0.0,
        "neutral":0.0,
        "total_count":0.0,
        "day":6
      },
      {
        "happy":0.0,
        "sad":0.0,
        "neutral":0.0,
        "total_count":0.0,
        "day":7
      }];


    DateTimeRange dateRangeRes = getDataFromRange(week);

    final journalRef = journal_db.collection('journals')
        .where("user_id", isEqualTo: uid)
        .where("created_at", isGreaterThanOrEqualTo: dateRangeRes.start)
        .where("created_at", isLessThanOrEqualTo: dateRangeRes.end);

    QuerySnapshot<Map<String, dynamic>> res = await journalRef.get();

    for (var docSnapshot in res.docs) {
      final data = docSnapshot.data();
      final DateTime date = (data["created_at"] as Timestamp).toDate();
      statsRes[date.weekday - 1]["total_count"] ++;
      if (data["mood"] == "happy") {
        statsRes[date.weekday - 1]["happy"] ++;
      }
      if (data["mood"] == "neutral") {
        statsRes[date.weekday - 1]["neutral"] ++;
      }
      if (data["mood"] == "sad") {
        statsRes[date.weekday - 1]["sad"] ++;
      }
    }

    return statsRes;

  }

  DateTimeRange getDataFromRange(String week_choice) {
    final now = DateTime.now();
    DateTime start = DateTime(2026);
    DateTime end = DateTime(2026);

    if (week_choice == "this week") {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0);

      final endOfWeek = start.add(const Duration(days: 6));
      end = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59);
    }

    if (week_choice == "last week") {

      // Get start of THIS week (Monday), then subtract 7 days
      final startOfThisWeek = now.subtract(Duration(days: now.weekday - 1));

      start = DateTime(startOfThisWeek.year, startOfThisWeek.month, startOfThisWeek.day)
          .subtract(const Duration(days: 7));

      end = DateTime(start.year, start.month, start.day, 23, 59, 59)
          .add(const Duration(days: 6));


    }

    return DateTimeRange(start: start, end: end);

  }

}
