import 'package:diary/services/journal_service.dart';
import 'package:diary/ui_widgets/StyledButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/journal.dart';
import '../../models/journal_model.dart';
import '../../theme.dart';
import '../../ui_widgets/EntryListItem.dart';

class EntryListContent extends StatefulWidget {
  const EntryListContent({super.key});

  @override
  State<EntryListContent> createState() => _EntryListContentState();
}

class _EntryListContentState extends State<EntryListContent> {

  late Future<List<JournalModel>> _journalsFuture;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState(){
    super.initState();
    _journalsFuture = loadJournals();
  }

  Future<List<JournalModel>> loadJournals() async{
    JournalService jservice = JournalService();
    return await jservice.readAllJournalEntriesByCurrentUser(user!.uid);

  }

  void refreshJournals() {
    setState(() {
      _journalsFuture = loadJournals();
    });
  }


  @override
  Widget build(BuildContext context) {


    return Column(
            children: [
              SizedBox(height:50),
              Center(child:Text("Entries", style:Theme.of(context).textTheme.displayLarge),),
              SizedBox(height:50),
              Expanded(child:
              FutureBuilder<List<JournalModel>> (
                  future: _journalsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("An error occurred"));
                    }else if(!snapshot.hasData) {
                      return Center(child: Text("No data found"));
                    }
                    else{
                      List<JournalModel> journals = snapshot.data!;

                      if(snapshot.data!.length == 0) {
                        return Center(child:
                        Text("You don't have any entries at the moment",
                          style: Theme.of(context).textTheme.headlineLarge ,),);
                      }

                      return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: journals.length,
                          itemBuilder: (BuildContext context,int index ) {
                            return Container(
                                color: AppColors.primaryPurple,
                                child: EntryListItem(journal: journals[index], onDeleted:(){
                                  print("reload data");
                                  refreshJournals();
                                })
                            );
                          });
                    }
                  }
              ),),
              SizedBox(height:50),
            ]
        );
  }
}






