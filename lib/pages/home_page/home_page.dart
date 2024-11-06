import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_games/pages/account_page/login_page.dart';
import 'package:mobile_games/pages/account_page/profile_page.dart';
import 'package:mobile_games/pages/account_page/register_page.dart';
import 'package:mobile_games/pages/games_page/game_page.dart';
import 'package:provider/provider.dart';
import 'package:mobile_games/timer_provider.dart';
import 'package:mobile_games/theme_provider.dart';
import 'package:mobile_games/pages/friends_page/friend_page.dart';
import 'package:mobile_games/pages/games_page/crossword/crossword_game_page.dart';
import 'package:mobile_games/pages/games_page/link/link_game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Set to `false` when maintenance is over
  final bool _isMaintenance = true;

  // List of pages for navigation
  static const List<Widget> _pages = <Widget>[
    SizedBox.shrink(), // Placeholder for home content
    GamePage(),
    FriendPage(),
  ];

  // Handle bottom navigation bar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Function to show login/register dialog
  void _showLoginRegisterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Profile'),
          content:
              const Text('Please log in or register to access your profile.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text('Register'),
            ),
          ],
        );
      },
    );
  }

  // Format duration for display
  String _formatDuration(Duration duration) {
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  // Build the maintenance banner
  Widget _buildMaintenanceBanner() {
    return Container(
      width: double.infinity,
      color: Colors.orangeAccent,
      padding: const EdgeInsets.all(8.0),
      child: const Text(
        "Periodic maintenance 12/11/24 from 8 - 10 a.m.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  // Build the blocked screen when the user is blocked
  Widget _buildBlockedScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: 100, color: Theme.of(context).iconTheme.color),
          const SizedBox(height: 20),
          const Text(
            'REST YOUR EYES',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  // Build the app name display as an image
  Widget _buildAppName() {
    return Center(
      child: Image.asset(
        'assets/appname1.png', // Path to your logo image
        height: 250, // Adjust the size as needed
        width: 450,
      ),
    );
  }

  // Build a card for each game
  Widget _buildGameCard({
    required String imagePath,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 4,
        child: Column(
          children: [
            // Game Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.asset(
                imagePath,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Game Title
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TimerProvider, ThemeProvider>(
      builder: (context, timerProvider, themeProvider, child) {
        // Obtain theme and mode
        final theme = Theme.of(context);
        final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.appBarTheme.backgroundColor,
            title: timerProvider.isBlocked
                ? Text(
                    "Blocked: ${_formatDuration(timerProvider.remainingBlockTime)}",
                    style: theme.appBarTheme.titleTextStyle,
                  )
                : Text(
                    "Remaining Time: ${_formatDuration(timerProvider.remainingUsageTime)}",
                    style: theme.appBarTheme.titleTextStyle,
                  ),
            centerTitle: true,
            elevation: 1,
            iconTheme: theme.iconTheme,
            leading: IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  // Navigate to ProfilePage if user is logged in
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(user: user),
                    ),
                  );
                } else {
                  // Show login/register dialog if not logged in
                  _showLoginRegisterDialog();
                }
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
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
                      children: [
                        if (_isMaintenance) _buildMaintenanceBanner(),
                        Expanded(
                          child: ListView(
                            children: [
                              const SizedBox(height: 20),
                              _buildAppName(),
                              const SizedBox(height: 20),
                              _buildGameCard(
                                imagePath: 'assets/game1.png',
                                title: 'Crossword Game',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CrosswordGamePage(),
                                    ),
                                  );
                                },
                              ),
                              _buildGameCard(
                                imagePath: 'assets/game2.png',
                                title: 'Link Game',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LinkGamePage(),
                                    ),
                                  );
                                },
                              ),
                            ],
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
            selectedItemColor: theme.primaryColor,
            unselectedItemColor: theme.disabledColor,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}
