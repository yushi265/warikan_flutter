import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  const Footer();

  @override
  _Footer createState() => _Footer();
}

class _Footer extends State {
  int _selectedIndex = 0;

  void _onTap(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home2'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home3'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home4'),
        ),
      ],
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _onTap,
    );
  }
}