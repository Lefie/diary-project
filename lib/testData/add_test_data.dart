

import 'package:diary/models/journal_model.dart';
import 'dart:math';

import 'package:diary/services/journal_service.dart';

final journalContent = ["Today was absolutely wonderful! I got a promotion at work and my friends threw me a surprise party. I feel so loved and grateful for everything in my life.",
  "Woke up feeling on top of the world today. Had a great workout, cooked my favorite meal, and spent the evening laughing with family. Life couldn't be better right now.",
  "Just got back from the most amazing trip. The scenery was breathtaking and I made memories I'll never forget. I wish every day could feel this magical.",
  "Today was pretty ordinary. Went to work, came home, made dinner. Nothing special happened but nothing went wrong either.",
  "Spent most of the day running errands and catching up on chores. Watched a bit of TV in the evening. Just another regular day.",
  "Felt a bit tired today but managed to get through everything on my to-do list. Not a bad day, not a great one either.",
  "I've been feeling really lonely lately and I'm not sure why. Even surrounded by people, something feels missing. I hope this feeling passes soon.",
  "Got some bad news today and it hit harder than I expected. I tried to stay positive but it was difficult to focus on anything else. I just need some time.",
  "Missing someone I lost today more than usual. The silence in the house feels so heavy. I hope tomorrow brings a little more light.",];
final journalMood = ["happy", "neutral", "sad"];
final userIds = ["2gTDrddSJ6S7rXIHFAzDzrxyniT2", "NAwoTxsOc3RC6ICVjSC186p5Jtj2", "xYiQdfTXOsgJllgHMuJU5Vla2WK2"];
final _random = Random();


void createJournalForUser() async{
  int randomIndexMood = _random.nextInt(journalMood.length);
  int randomIndexUserid = _random.nextInt(userIds.length);

  final now = DateTime.now();
  final daysAgo = _random.nextInt(20) + 1;
  final date = now.subtract(Duration(days: daysAgo));
  int randomIndexContent = _random.nextInt(journalContent.length);

  final content = journalContent[randomIndexContent];
  final mood = journalMood[randomIndexMood];
  final user_id = userIds[randomIndexUserid];

  JournalModel j = JournalModel(content: content, mood: mood, created_at: date, user_id: user_id);
  JournalService jserive = JournalService();
  await jserive.addData(j);

}

void addLotsOfData(int amount) {
  for (int i = 0; i < amount; i++) {
    createJournalForUser();
  }
}