import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_games/pages/account_page/profile_page.dart';
import 'package:mobile_games/pages/games_page/game_page.dart';
import 'package:provider/provider.dart';
import 'package:mobile_games/timer_provider.dart';
import 'package:mobile_games/theme_provider.dart'; // Import ThemeProvider
import 'package:mobile_games/pages/friends_page/friend_page.dart';
import 'package:mobile_games/pages/games_page/crossword/crossword_game_page.dart';
import 'package:mobile_games/pages/games_page/link/link_game_page.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Home Page Content', style: TextStyle(fontSize: 24))),
    GamePage(),
    FriendPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TimerProvider, ThemeProvider>(
      builder: (context, timerProvider, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(user: widget.user),
                  ),
                );
              },
            ),
            title: timerProvider.isBlocked
                ? Text(
                    "Blocked: ${_formatDuration(timerProvider.remainingBlockTime)}",
                    style: const TextStyle(color: Colors.black),
                  )
                : Text(
                    "Remaining Time: ${_formatDuration(timerProvider.remainingUsageTime)}",
                    style: const TextStyle(color: Colors.black),
                  ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  themeProvider.themeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Colors.black,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.black),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ],
          ),
          body: timerProvider.isBlocked
              ? _buildBlockedScreen()
              : (_selectedIndex == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CrosswordGamePage()),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(16.0),
                            height: MediaQuery.of(context).size.height * 0.35,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage('assets/game1.png'),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LinkGamePage()),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(16.0),
                            height: MediaQuery.of(context).size.height * 0.35,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage('assets/game2.png'),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(),
                          ),
                        ),
                      ],
                    )
                  : _pages[_selectedIndex]),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.videogame_asset),
                label: 'Games',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Friends',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: themeProvider.themeMode == ThemeMode.light
                ? Colors.black
                : Colors.white,
            unselectedItemColor: themeProvider.themeMode == ThemeMode.light
                ? Colors.grey
                : Colors.grey[400],
            backgroundColor: themeProvider.themeMode == ThemeMode.light
                ? Colors.white
                : Colors.black,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Widget _buildBlockedScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.lock, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'REST YOUR EYES',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
