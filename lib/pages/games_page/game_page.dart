import 'package:flutter/material.dart';
import 'package:mobile_games/pages/games_page/crossword_game_page.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous page
          },
        ),
        title: const Text('Game', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // Action for settings icon
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to Crossword Game only
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameSelectionPage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.grey[300],
                    height: 150,
                    child: const Center(
                      child: Text('Game 1: Crossword'),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.grey[300],
                  height: 150,
                  child: const Center(
                    child: Text(
                        'Game 2: Coming Soon'), // Placeholder for second game, non-clickable
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
