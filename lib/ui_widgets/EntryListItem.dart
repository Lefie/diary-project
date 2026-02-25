import 'package:diary/services/journal_service.dart';
import 'package:diary/theme.dart';
import 'package:diary/ui_widgets/DateTime.dart';
import 'package:diary/ui_widgets/StyledButton.dart';
import 'package:flutter/material.dart';
import '../models/journal_model.dart';
import '../screens/Entry/Entry_Screen.dart';

class EntryListItem extends StatelessWidget {
  const EntryListItem({super.key, required this.journal, required this.onDeleted});

  final JournalModel journal;
  final Function() onDeleted;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Container(
        decoration: BoxDecoration(
        color: AppColors.secondaryPurple,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        margin: EdgeInsets.only(left:16, right:16),
        child:
          Padding(
        padding: EdgeInsets.all(10),
        child: Row(
        children: [
          StyledEmojiButton(emoji: (journal.mood == "happy" ? AppEmojis.happy : (journal.mood == "sad" ? AppEmojis.sad: journal.mood == "neutral" ? AppEmojis.neutral : "") )  , onPressed: (){}, isSelected: false,),
          SizedBox(width:10),
          Expanded(child: Text(journal.content, maxLines: 1,overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.bodyMedium,)),
          SizedBox(width:10),
          ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => Entry(entry_id: journal.journal_id!,),
                  ),
                );
              },
              child: Icon(Icons.arrow_forward, color:Colors.white),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
          )
          ],
        ),
        ),
        ),
      Container(
        margin: EdgeInsets.only(left:21),
        width: double.infinity,
        child: Row(children: [
          DateTimeUI(j: journal ),
          Expanded(child: SizedBox()),
          TextButton(
            onPressed: () async {
              print("${journal.journal_id} is clicked");
              JournalService service = JournalService();
              await service.deleteJournal(journal.journal_id!);
              onDeleted();
            },
            child: Icon(Icons.delete, color: Colors.white,),),
        ],))
      ],);
  }
}