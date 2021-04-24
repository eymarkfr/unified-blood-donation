import 'package:flutter/material.dart';
import 'package:ubd/views/home/profile.dart';
import 'package:ubd/views/quick_id.dart';
import 'package:ubd/views/auth/sign_up.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
        accentColor: Color(0xFFC40F0F).withOpacity(0.0784313725490196),
        backgroundColor: Colors.white,
        textTheme: TextTheme(
          headline3: TextStyle(color: Color(0xff191919), fontSize: 24),
          headline4: TextStyle(color: Color(0xff191919), fontSize: 20, fontWeight: FontWeight.bold),
          subtitle1: TextStyle(color: Color(0xff191919), fontSize: 14),
          subtitle2: TextStyle(color: Color(0xaa191919), fontSize: 14),
          bodyText2: TextStyle(color: Colors.black, fontSize: 14)
        ),
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

  Widget _getView(int index) {
    switch(index) {
      case 0:
      case 1:
      case 2:
      case 3:
      default:
        return ProfileView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _getView(_bottomNavbarIndex),),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavbarIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (newIndex){
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
      ),
    );
  }
}
