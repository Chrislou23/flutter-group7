import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_games/pages/games_page/crossword/Instructions/crossword_instructions_en.dart';
import 'package:mobile_games/pages/games_page/crossword/Instructions/crossword_instructions_fi.dart';
import 'package:mobile_games/pages/games_page/link/Instructions/link_instructions_en.dart';
import 'package:mobile_games/pages/games_page/link/Instructions/link_instructions_fi.dart';
import 'package:mobile_games/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/home_page/home_page.dart';
import 'pages/account_page/login_page.dart';
import 'pages/account_page/register_page.dart';
import 'pages/games_page/game_page.dart';
import 'pages/friends_page/friend_page.dart';
import 'pages/games_page/crossword/crossword_game_page.dart';
import 'pages/games_page/link/link_game_page.dart';
import 'pages/settings_page/settings_page.dart';
import 'pages/settings_page/data_protection_policy.dart';
import 'pages/settings_page/about_page.dart';
import 'timer_provider.dart';

void main() async {
  // Ensures that widget binding is initialized before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes Firebase before the app starts
  await Firebase.initializeApp();

  // Runs the app with multiple providers for state management
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtain the ThemeProvider to manage theme changes
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game App',
      // Apply the current theme mode (light or dark)
      themeMode: themeProvider.themeMode,
      // Define the light theme settings
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        // You can define other light theme properties here
      ),
      // Define the dark theme settings
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue, // Set the button color
          textTheme: ButtonTextTheme.primary,
        ),
        // You can define other dark theme properties here
      ),
      // Set the initial route of the app
      home: const HomePage(),
      // Define the routes for navigation within the app
      routes: {
        '/game': (context) => const GamePage(),
        '/friends': (context) => const FriendPage(),
        '/account': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/crossword': (context) => const CrosswordGamePage(),
        '/link': (context) => const LinkGamePage(),
        '/link_instructions_en': (context) => const LinkInstructionsEn(),
        '/link_instructions_fi': (context) => const LinkInstructionsFi(),
        '/crossword_instructions_en': (context) => const CrosswordInstructionsEn(),
        '/crossword_instructions_fi': (context) => const CrosswordInstructionsFi(),
        '/settings': (context) => const SettingsPage(),
        '/data_protection_policy': (context) => const DataProtectionPolicyPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}
