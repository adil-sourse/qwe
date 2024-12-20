import 'package:flutter/cupertino.dart';
import 'package:qwe/src/screens/chat/chat_screen.dart';
import 'package:qwe/src/screens/main/main_screen.dart';
import 'package:qwe/src/screens/settings/setting_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    MainScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Stack(
        children: [
          CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              backgroundColor: CupertinoColors.black,
              activeColor: CupertinoColors.activeGreen,
              inactiveColor: CupertinoColors.white.withOpacity(0.2),
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/grid.png',
                    width: 20,
                  ),
                  label: 'Главная',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/settings.png',
                    width: 20,
                  ),
                  label: 'Настройки',
                ),
              ],
            ),
            tabBuilder: (BuildContext context, int index) {
              return pages[index];
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => ChatScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: CupertinoColors.black,
                ),
                child: Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 100, 224, 164),
                        Color.fromARGB(255, 12, 165, 37)
                      ],
                    ),
                  ),
                  child: Image.asset(
                    "assets/icons/message.png",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
