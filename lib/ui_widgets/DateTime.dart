
import 'package:flutter/cupertino.dart';

import '../models/journal.dart';
import '../models/journal_model.dart';

class DateTimeUI extends StatelessWidget{
  const DateTimeUI({super.key, required this.j});

  final JournalModel j;

  @override
  Widget build(BuildContext context) {
    return Text("${j.created_at.month}/${j.created_at.day}/${j.created_at.year} ${j.created_at.hour}:${j.created_at.minute}");
  }
}