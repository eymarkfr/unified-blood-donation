import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubd/models/blood_bank.dart';
import 'package:ubd/views/home/heroes.dart';
import 'package:ubd/views/home/history.dart';
import 'package:ubd/views/home/home.dart';
import 'package:ubd/views/home/profile.dart';
import 'package:ubd/views/auth/sign_up.dart';
import 'package:ubd/widgets/blood_bank_card.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          log(snapshot.error.toString());
          return Container();
        }
        if(snapshot.connectionState == ConnectionState.done) {
          return MainApp();
        }

        return MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Map<int, Color> color =
    {
      50: Color.fromRGBO(196, 15, 15, 0.1),
      100:Color.fromRGBO(196, 15, 15, .2),
      200:Color.fromRGBO(196, 15, 15, .3),
      300:Color.fromRGBO(196, 15, 15, .4),
      400:Color.fromRGBO(196, 15, 15, .5),
      500:Color.fromRGBO(196, 15, 15, .6),
      600:Color.fromRGBO(196, 15, 15, .7),
      700:Color.fromRGBO(196, 15, 15, .8),
      800:Color.fromRGBO(196, 15, 15, .9),
      900:Color.fromRGBO(196, 15, 15, 1),
    };
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
          primarySwatch: MaterialColor(0xFFC40F0F, color),
          accentColor: Color(0xFFFBEEEE),
          backgroundColor: Colors.white,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            headline3: TextStyle(color: Color(0xff191919), fontSize: 24),
            headline4: TextStyle(color: Color(0xff191919), fontSize: 20, fontWeight: FontWeight.bold),
            headline5: TextStyle(color: Color(0xff191919), fontSize: 15, fontWeight: FontWeight.bold),
            subtitle1: TextStyle(color: Color(0xff191919), fontSize: 14),
            subtitle2: TextStyle(color: Color(0xaa191919), fontSize: 14),
            bodyText2: TextStyle(color: Colors.black, fontSize: 14),
          ),
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent)
      ),
      home: MyHomePage(), //SingUpPage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _bottomNavbarIndex = 0;
  PersistentBottomSheetController? _sheetController;
  PageController? _pageController;
  User? _user;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  List<Widget> _getViews(){
    return [
      HomeView(setSheetController: (controller){
        _sheetController = controller;
      },),
      HistoryView(),
      HeroesView(),
      ProfileView()
    ];
  }

  @override
  Widget build(BuildContext context) {
    if(_user == null) {
      return SingUpPage();
    }

    return Scaffold(
      body: SafeArea(
          child: _getViews()[_bottomNavbarIndex]
     ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _bottomNavbarIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (newIndex){
          _sheetController?.close();
          _sheetController = null;
          setState(() {
            _bottomNavbarIndex = newIndex;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_sharp), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.group_rounded), label: 'Heroes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
      )
    );
  }
}
