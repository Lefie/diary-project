import 'package:diary/models/journal.dart';
import 'package:diary/services/journal_service.dart';
import 'package:diary/ui_widgets/StyledButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diary/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/journal_model.dart';
import '../EntryList/EntryList_Screen.dart';

class JournalScreenContent extends StatefulWidget {
  const JournalScreenContent({super.key});

  @override
  State<JournalScreenContent> createState() => _JournalScreenContentState();
}

class _JournalScreenContentState extends State<JournalScreenContent>{
  User? user = FirebaseAuth.instance.currentUser;

  final journalController = TextEditingController();
  String _selected_mood = "";

  @override
  void dispose() {
    journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height:50),
                Text("Journal", style: Theme.of(context).textTheme.displayLarge,),
                SizedBox(height:30),
                Container(
                    width: 300,
                    height:300,
                    child: TextField(
                      controller: journalController,
                      keyboardType: TextInputType.multiline,
                      expands: true,
                      maxLines: null,
                      style: GoogleFonts.lexend(color:Colors.black, fontSize: 18),
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.lightPink,
                        hintText: "...How are you feeling?",
                        hintStyle: GoogleFonts.lexend(color:Colors.black, fontSize: 18),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,  // No border
                        ),
                      ),
                    )),
                SizedBox(height:30),
                Text("Choose your mood", style:Theme.of(context).textTheme.displayLarge),
                SizedBox(height:15),
                Container(
                    width: 300,
                    height:90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.secondaryPurple,
                    ) ,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child:
                      Row(
                        children: [
                          SizedBox(width: 20,),
                          StyledEmojiButton(
                            emoji: AppEmojis.happy,
                            onPressed: (){
                              setState(() {
                                _selected_mood = "happy";
                              });
                            },
                            isSelected: _selected_mood == "happy",
                          ),
                          SizedBox(width: 20,),
                          StyledEmojiButton(
                            emoji: AppEmojis.neutral,
                            onPressed: (){
                              setState(() {
                                _selected_mood = "neutral";},
                              );
                            },
                            isSelected: _selected_mood == "neutral",
                          ),
                          SizedBox(width: 20,),
                          StyledEmojiButton(emoji: AppEmojis.sad, onPressed: (){
                            setState(() {
                              _selected_mood = "sad";
                            });
                          }, isSelected: _selected_mood == "sad"),

                        ],)
                      ,)

                ),
                SizedBox(height:40),
                StyledButtonLite(
                    child: Text("Submit", style: Theme.of(context).textTheme.headlineLarge),
                    onPressed: () async{
                      print("here is what's written : ${journalController.text}");
                      print("and here is emoji selected: ${_selected_mood}");

                      JournalService service = JournalService();

                      JournalModel journal = JournalModel(
                          content:journalController.text,
                          mood: _selected_mood,
                          created_at:DateTime.now(),
                          user_id: user!.uid
                      );


                      await service.addData(journal);

                      setState(() {
                        _selected_mood = "";
                        journalController.clear();
                      });

                    }),
                SizedBox(height:25)
              ],)
        ),);
  }
}

