import 'package:flutter/material.dart';
import 'package:mobile_games/pages/games_page/link/link_instructions_fi.dart';
import 'package:provider/provider.dart';
import 'pages/home_page/home_page.dart';
import 'pages/games_page/game_page.dart';
import 'pages/friends_page/friend_page.dart';
import 'pages/games_page/crossword/crossword_game_page.dart';
import 'pages/games_page/link/link_game_page.dart';
import 'pages/games_page/link/link_instructions_en.dart';
import 'pages/games_page/crossword/crossword_instructions_en.dart';
import 'pages/games_page/crossword/crossword_instructions_fi.dart';
import 'pages/games_page/link/link_game_page.dart';
import 'pages/account_page/account_page.dart';
import 'timer_provider.dart';


void main() {
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
      navigatorKey: navigatorKey, // Utilisez le navigatorKey global ici
      debugShowCheckedModeBanner: false,
      title: 'Game App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ResponsiveHomePage(), // Use a responsive home page
      routes: {
        '/game': (context) => const GamePage(),
        '/friends': (context) => const FriendPage(),
        '/account': (context) => const LoginPage()
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
      );
    }
  }
}
        '/crossword': (context) => const CrosswordGamePage(),
        '/link': (context) => const LinkGamePage(),
        '/link_instructions_fi': (context) => const LinkInstructionsFi(),
        '/link_instructions_en': (context) => const LinkInstructionsEn(),
        '/crossword_instructions': (context) => const CrosswordInstructionsEn(),
        '/crossword_instructions_fi': (context) =>
            const CrosswordInstructionsFi(),
        '/link': (context) => const LinkGamePage(),
        '/account': (context) => const LoginPage(),
      },
    );
  }
}