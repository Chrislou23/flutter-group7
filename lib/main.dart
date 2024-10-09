import 'package:flutter/material.dart';
import 'pages/home_page/home_page.dart';
import 'pages/games_page/game_page.dart';
import 'pages/friends_page/friend_page.dart';
import 'pages/games_page/crossword/crossword_game_page.dart';
import 'pages/games_page/crossword/crossword_instructions_en.dart';
import 'pages/games_page/crossword/crossword_instructions_fi.dart';
import 'pages/games_page/link/link_game_page.dart';

void main() {
  runApp(const MyApp());
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
      home: const HomePage(), // Start with the HomePage
      routes: {
        '/game': (context) => const GamePage(),
        '/friends': (context) => const FriendPage(),
        '/crossword': (context) => const CrosswordGamePage(),
        '/crossword_instructions': (context) => const CrosswordInstructionsEn(),
        '/crossword_instructions_fi': (context) =>
            const CrosswordInstructionsFi(),
        '/link': (context) => const LinkGamePage(),
      },
    );
  }
}
