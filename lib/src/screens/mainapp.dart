import 'package:DemoMenu/src/screens/addrdv.dart';
import 'package:DemoMenu/src/screens/login.dart';
import 'package:DemoMenu/src/screens/map.dart';
import 'package:DemoMenu/src/screens/rdv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 1;
  List<Widget> widgetsNavigation = [Map(), Rdv(), AddRdv()];
  final auth = FirebaseAuth.instance;

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppFlutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('RDVApp'),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20),
                child: GestureDetector(
                    onTap: () {
                      print(auth.currentUser);
                      auth.signOut();

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                    child: Icon(Icons.logout)))
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: 'RDV'),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle), label: 'Nouveau RDV'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTap,
        ),
        body: widgetsNavigation.elementAt(_selectedIndex),
      ),
    );
  }
}
