import 'dart:convert';

import 'package:diary/screens/Stats/StatsContent.dart';
import 'package:diary/services/user_service.dart';
import 'package:diary/ui_widgets/StyledButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart';
import 'package:http/http.dart' as http;

class PersonalHomeContent extends StatefulWidget{
  const PersonalHomeContent({super.key});


  @override
  State<PersonalHomeContent> createState() => _PersonalHomeContentState();

}

class _PersonalHomeContentState extends State<PersonalHomeContent> with SingleTickerProviderStateMixin {

  final User? user = FirebaseAuth.instance.currentUser;
  late UserModel? currentUser;
  bool _isLoading = true;
  double _actualTemp = 0.0;
  double _feelsLikeTemp = 0.0;
  late TabController _tabController;

  static const List<Tab> myTabs = <Tab>[
    Tab(text: "This week", ),
    Tab(text: 'Last week'),
    Tab(text: 'Total Stats',)
  ];


  @override
  void initState() {
    super.initState(); // Always call super.initState() first
    _tabController = TabController(length: myTabs.length, vsync: this);
    getLoggedInUser();
    getCurrentTemp();
  }

  void getLoggedInUser() async{
      print("get loggedin user");
      UserService userService = UserService();
      final data = await userService.getUserById(user!.uid);

      if (!mounted) return;

      setState(() {
        currentUser = data;
        _isLoading = false;
      });
  }

  Future<void> getCurrentTemp() async{
    print("get current temp");
    final String url = "https://api.open-meteo.com/v1/forecast?latitude=40.71&longitude=-74.01&current=temperature_2m&current=apparent_temperature&timezone=America%2FNew_York&temperature_unit=fahrenheit";
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> res = jsonDecode(response.body) as Map<String, dynamic>;
      final currentTemp = res["current"]["temperature_2m"];
      final feelsLikeTemp = res["current"]["apparent_temperature"];
      print("Current Tempt is ${currentTemp} but feels like ${feelsLikeTemp}");

      setState(() {
        _actualTemp = currentTemp;
        _feelsLikeTemp = feelsLikeTemp;
      });

    }else {
      throw Exception("error getting weather data");
    }

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    if (_isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (currentUser == null) {
      return Center(
        child: Text("Failed to fetch current user data"),
      );
    }


    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child:
          Container(
            width: double.infinity,
            child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height:50),
              Text("Welcome, ${currentUser!.username[0].toUpperCase() +currentUser!.username.substring(1) }",style: Theme.of(context).textTheme.displayLarge,),
              SizedBox(height: 50,),
              Text("${DateTime.now().month}/${DateTime.now().day}/ ${DateTime.now().year}",
              style: GoogleFonts.lexend(textStyle: TextStyle(fontSize: 32))),
              SizedBox(height: 20,),
              Text("${_actualTemp} F but feels like ${_feelsLikeTemp} F"),
              SizedBox(height: 50,),
              Container(child:
              Padding(padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: myTabs,
                      labelColor: Colors.white,
                    ),
                    SizedBox(
                      height:300,
                    child: TabBarView(
                        controller: _tabController,
                        children: myTabs.map((Tab tab){
                            final String text = tab.text!.toLowerCase();
                            return Padding(
                              padding: EdgeInsets.all(16),
                              child:StatsContent(type: text)
                              );
                        }).toList()) ,)

                  ],) ,
              )
          ),
        ],
        ),
          ),
  );
  }
}