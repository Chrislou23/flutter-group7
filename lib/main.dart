import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'pages/account_page/login_page.dart';
import 'pages/account_page/register_page.dart';
import 'pages/games_page/game_page.dart';
import 'pages/friends_page/friend_page.dart';
import 'pages/games_page/crossword/crossword_game_page.dart';
import 'pages/games_page/link/link_game_page.dart';
import 'pages/games_page/link/link_instructions_en.dart';
import 'pages/games_page/link/link_instructions_fi.dart';
import 'pages/games_page/crossword/crossword_instructions_en.dart';
import 'pages/games_page/crossword/crossword_instructions_fi.dart';
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
      home: const LoginPage(),
      routes: {
        '/game': (context) => const GamePage(),
        '/friends': (context) => const FriendPage(),
        '/account': (context) => const LoginPage(),
        '/crossword': (context) => const CrosswordGamePage(),
        '/link': (context) => const LinkGamePage(),
        '/link_instructions_fi': (context) => const LinkInstructionsFi(),
        '/link_instructions_en': (context) => const LinkInstructionsEn(),
        '/crossword_instructions': (context) => const CrosswordInstructionsEn(),
        '/crossword_instructions_fi': (context) =>
            const CrosswordInstructionsFi(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
