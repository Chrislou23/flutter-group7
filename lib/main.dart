import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'pages/home_page/home_page.dart';
import 'pages/friends_page/friend_page.dart';
import 'pages/games_page/crossword/crossword_game_page.dart';
import 'pages/games_page/link/link_game_page.dart';
import 'pages/games_page/link/link_instructions_en.dart';
import 'pages/games_page/link/link_instructions_fi.dart';
import 'pages/games_page/crossword/crossword_instructions_en.dart';
import 'pages/games_page/crossword/crossword_instructions_fi.dart';
import 'pages/account_page/account_page.dart';
import 'pages/settings_page/settings_page.dart';
import 'pages/settings_page/data_protection_policy.dart';
import 'pages/settings_page/privacy_page.dart';
import 'pages/settings_page/about_page.dart';
import 'timer_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/game': (context) => const CrosswordGamePage(),
        '/friends': (context) => const FriendPage(),
        '/crossword': (context) => const CrosswordGamePage(),
        '/crossword_instructions_en': (context) =>
            const CrosswordInstructionsEn(),
        '/crossword_instructions_fi': (context) =>
            const CrosswordInstructionsFi(),
        '/link': (context) => const LinkGamePage(),
        '/link_instructions_en': (context) => const LinkInstructionsEn(),
        '/link_instructions_fi': (context) => const LinkInstructionsFi(),
        '/account': (context) => const LoginPage(),
        '/settings': (context) => const SettingsPage(),
        '/data_protection_policy': (context) =>
            const DataProtectionPolicyPage(),
        '/privacy': (context) => const PrivacyPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}

class ResponsiveHomePage extends StatelessWidget {
  const ResponsiveHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    if (screenSize.width < 600) {
      // Mobile layout
      return const HomePage();
    } else {
      // Tablet/Desktop layout
      return Scaffold(
        appBar: AppBar(
          title: const Text('Game App - Tablet/Desktop Layout'),
        ),
        body: const Center(
          child: Text('Welcome to the desktop version of the Game App'),
        ),
      );
    }
  }
}
