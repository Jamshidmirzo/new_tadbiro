import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:new_firebase/controllers/user_controller.dart';
import 'package:new_firebase/models/user.dart';
import 'package:new_firebase/services/auth_firebase_service.dart';
import 'package:new_firebase/views/screens/evets_screen.dart';
import 'package:new_firebase/views/screens/home_screen.dart';
import 'package:new_firebase/views/screens/profile_screen.dart';
import 'package:new_firebase/views/screens/signinpage.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final firebaseservice = AuthFirebaseService();
  bool _isDarkMode = false;
  Users? _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser(context);
    AdaptiveTheme.getThemeMode().then((themeMode) {
      setState(() {
        _isDarkMode = (themeMode == AdaptiveThemeMode.dark);
      });
    });
  }

  void _fetchCurrentUser(BuildContext context) async {
    final userController = context.read<UserController>();

    try {
      Users user = await userController.getUsersSortedByUid();
      setState(() {
        _currentUser = user;
      });
    } catch (e) {
      print('Failed to fetch user: $e');
      setState(() {
        _currentUser = null;
      });
    }
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    if (_isDarkMode) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setLight();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 238, 173, 76),
            ),
            accountName: _currentUser != null
                ? Text(
                    _currentUser!.firstName,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  )
                : const Text('Nou name'),
            accountEmail: _currentUser != null
                ? Text(_currentUser!.email)
                : const Text(''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: _currentUser != null
                  ? NetworkImage(_currentUser!.imageUrl)
                  : null,
              child: _currentUser == null || _currentUser!.imageUrl.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
          ),
          ZoomTapAnimation(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            child: ListTile(
              leading: Icon(Icons.home),
              title: Text(tr('home')),
            ),
          ),
          ZoomTapAnimation(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(tr('profile')),
            ),
          ),
          ZoomTapAnimation(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EvetsScreen(),
                ),
              );
            },
            child: ListTile(
              leading: Icon(Icons.event),
              title: Text(tr('events')),
            ),
          ),
          SwitchListTile(
            title: Text(tr('qm')),
            secondary: const Icon(Icons.settings),
            value: _isDarkMode,
            onChanged: _toggleTheme,
          ),
          ZoomTapAnimation(
            onTap: () async {
              Locale? selectedLocale = await showDialog<Locale>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(tr('select_language')),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('English'),
                          onTap: () {
                            Navigator.pop(context, Locale('en'));
                          },
                        ),
                        ListTile(
                          title: Text('Русский'),
                          onTap: () {
                            Navigator.pop(context, Locale('ru'));
                          },
                        ),
                        ListTile(
                          title: Text('Oʻzbek'),
                          onTap: () {
                            Navigator.pop(context, Locale('uz'));
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
              if (selectedLocale != null) {
                context.setLocale(selectedLocale);
              }
            },
            child: ListTile(
              leading: Icon(Icons.language),
              title: Text(tr('select_language')),
            ),
          ),
          const Spacer(),
          ZoomTapAnimation(
            onTap: () {
              firebaseservice.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Signinpage(),
                ),
              );
            },
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text(tr('logout')),
            ),
          ),
        ],
      ),
    );
  }
}
