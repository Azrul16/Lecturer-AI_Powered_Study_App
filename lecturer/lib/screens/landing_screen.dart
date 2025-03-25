import 'package:flutter/material.dart';
import 'package:lecturer/screens/floating_act.dart';
import 'package:lecturer/screens/home_screen.dart';
import 'package:lecturer/screens/notes_screen.dart';
import 'package:lecturer/screens/question_screen.dart';
import 'package:lecturer/screens/settings.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    QuestionScreen(),
    NotesScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color as per the image
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 1.0,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(40),
              bottom: Radius.circular(40),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  size: 30,
                  color: _selectedIndex == 0 ? Colors.orange : Colors.black,
                ),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.sim_card,
                  size: 30,
                  color: _selectedIndex == 1 ? Colors.orange : Colors.black,
                ),
                onPressed: () => _onItemTapped(1),
              ),
              SizedBox(width: 40), // Space for FAB
              IconButton(
                icon: Icon(
                  Icons.add_a_photo_rounded,
                  size: 30,
                  color: _selectedIndex == 2 ? Colors.orange : Colors.black,
                ),
                onPressed: () => _onItemTapped(2),
              ),
              IconButton(
                icon: Icon(
                  Icons.miscellaneous_services_sharp,
                  size: 30,
                  color: _selectedIndex == 3 ? Colors.orange : Colors.black,
                ),
                onPressed: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingMicWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _screens[_selectedIndex],
    );
  }
}
