import 'package:flutter/material.dart';

class Display extends StatelessWidget {
  const Display({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: ,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
      ),
      // body: ,
      body: Center(
        child: FlutterLogo(
          size: 100,
        ),
      ),
      // bottomNavigationBar: ,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      // bottomSheet: ,
      bottomSheet: Container(
        color: Colors.blue,
        height: 50,
        child: Center(
          child: Text(
            'This is a bottom sheet',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      // drawer: ,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle settings tap
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                // Handle about tap
              },
            ),
          ],
        ),
      ),
    );
  }
}
