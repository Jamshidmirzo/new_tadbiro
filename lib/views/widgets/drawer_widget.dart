import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_firebase/services/auth_firebase_service.dart';
import 'package:new_firebase/views/screens/evets_screen.dart';
import 'package:new_firebase/views/screens/home_screen.dart';
import 'package:new_firebase/views/screens/signinpage.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final firebaseservice = AuthFirebaseService();
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    AdaptiveTheme.getThemeMode().then((themeMode) {
      setState(() {
        _isDarkMode = (themeMode == AdaptiveThemeMode.dark);
      });
    });
  }

  void _toggleTheme(bool value) {
    setState(
      () {
        _isDarkMode = value;
      },
    );
    if (_isDarkMode) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setLight();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 238, 173, 76)),
            accountName: Text('John Doe'),
            accountEmail: Text('john.doe@example.com'),
            currentAccountPicture: CircleAvatar(),
          ),
          ZoomTapAnimation(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const HomeScreen();
                  },
                ),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ZoomTapAnimation(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EvetsScreen(),
                ),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.event),
              title: Text('Events'),
            ),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.settings),
            value: _isDarkMode,
            onChanged: _toggleTheme,
          ),
          const Spacer(),
          ZoomTapAnimation(
            onTap: () {
              firebaseservice.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Signinpage();
                  },
                ),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
