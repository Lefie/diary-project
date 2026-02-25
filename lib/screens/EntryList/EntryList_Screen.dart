import 'package:diary/screens/Home/Home_Screen.dart';
import 'package:diary/services/journal_service.dart';
import 'package:diary/ui_widgets/StyledButton.dart';
import 'package:flutter/material.dart';
import '../../models/journal.dart';
import '../../theme.dart';
import '../../ui_widgets/EntryListItem.dart';


/*
class EntryList extends StatefulWidget {
  const EntryList({super.key});

  @override
  State<EntryList> createState() => _EntryListState();
}
*/

/*
class _EntryListState extends State<EntryList> {

  late Future<List<Journal>> _journalsFuture;

  @override
  void initState(){
    super.initState();
    _journalsFuture = loadJournals();
  }

  Future<List<Journal>> loadJournals() async{
    JournalService jservice = JournalService();
    return await jservice.readAllJournals();
  }

  void refreshJournals() {
    setState(() {
      _journalsFuture = loadJournals();
    });
  }


  @override
  Widget build(BuildContext context) {


  return Scaffold(
      appBar: AppBar(),
      body: Column(
      children: [
      SizedBox(height:50),
      Center(child:Text("Entries", style:Theme.of(context).textTheme.displayLarge),),
      SizedBox(height:50),
      Expanded(child:
      FutureBuilder<List<Journal>> (
      future: _journalsFuture,
      builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text("An error occurred"));
      }else if(!snapshot.hasData) {
        return Center(child: Text("No data found"));
      }
      else{
        List<Journal> journals = snapshot.data!;

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
        StyledButtonLite(child: Text("Home", style: Theme.of(context).textTheme.headlineLarge,), onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen()));
        }),
        SizedBox(height: 30)
        ]
         )
        );
        }
  }
*/




