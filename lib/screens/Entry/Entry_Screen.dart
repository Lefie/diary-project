import 'package:diary/services/journal_service.dart';
import 'package:diary/ui_widgets/DateTime.dart';
import 'package:diary/ui_widgets/EmojiPanel.dart';
import 'package:diary/ui_widgets/StyledButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/journal.dart';
import '../../models/journal_model.dart';
import '../../theme.dart';



class Entry extends StatefulWidget {
  const Entry({super.key, required this.entry_id});

  final String entry_id;

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {

  late JournalModel current_journal;
  bool isloading = true;
  bool isEditing = false;
  late String prefilledString = "";
  late final journalController;
  String _selectedMood = "";
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {

    journalController.dispose();
    super.dispose();
  }


  Future<void> loadData() async{
    JournalService service = JournalService();
    JournalModel j = await service.readJournalById(widget.entry_id, user!.uid);

    setState(() {
      current_journal = j;
      prefilledString = current_journal.content;
      print("prefilled string ${prefilledString}");
      journalController =TextEditingController(text:prefilledString);
      isloading = false;
    });
  }

  Future<void> updateContent() async {
    JournalService service = JournalService();
    JournalModel j = await service.readJournalById(widget.entry_id, user!.uid);

    print("updated mood : ${j.mood}");
    setState(() {
      current_journal = j;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height:50),
            Center(child: Text("Entry", style: Theme.of(context).textTheme.displayLarge)),
            SizedBox(height:50,),
            isloading ? Text("loading"): Padding(
              padding: EdgeInsets.all(16),
              child: Column(children: [
                isEditing?
                Column(children: [
                  Container(
                    width: 300,
                    height:300,
                    child: TextField(
                      controller: journalController,
                      keyboardType: TextInputType.multiline,
                      expands: true,
                      maxLines: null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.lightPink,
                      ),
                    ),)
                ],)
                 :Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                  TextButton(onPressed: (){
                    print("edit");
                    setState(() {
                      isEditing = true;
                    });
                    },
                    child:  Icon(Icons.edit, color:Colors.white)),
                  Container(
                    color:AppColors.secondaryPurple,
                    height:350,
                    width:350,
                    child: isloading ? Text("loading"):
                    Padding(padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Expanded(child:
                          SingleChildScrollView(child:
                          Text(current_journal.content,
                            style:Theme.of(context).textTheme.bodyMedium,
                          ))),
                          SizedBox(height: 20,),
                          StyledEmojiButton(emoji: current_journal.mood == "happy" ? AppEmojis.happy : current_journal.mood == "sad"? AppEmojis.sad:AppEmojis.neutral, onPressed: (){}, isSelected: false),
                        ],
                      ),
                    ),
                  ) ,
                ],),
                SizedBox(height:10),
                DateTimeUI(j: current_journal),
                SizedBox(height:20),
                isEditing ? Column(
                  children: [
                  EmojiPanel(mood : current_journal.mood, onMoodChanged : (m){
                    setState(() {
                      _selectedMood = m;
                    });
                  }),
                  SizedBox(height:15),
                  StyledButtonLite(
                      child: Text("Save", style: Theme.of(context).textTheme.headlineLarge),
                      onPressed: () async{
                        print(journalController.text);
                        print(_selectedMood);
                        final Map<String, dynamic> json = {
                          "journal_id": widget.entry_id,
                          "content":"${journalController.text}",
                          "mood":_selectedMood,
                          "created_at": DateTime.now(),
                        };
                        print("selected mood ${_selectedMood}");
                        JournalService service = JournalService();
                        await service.updateJournal(widget.entry_id, json);
                        await updateContent();
                        setState(() {
                          isEditing = false;
                        });
                      }),
                ],):SizedBox(),


              ],) )
          ],
        ),
      )
    );
  }
}



