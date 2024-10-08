import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_games/pages/games_page/crossword/crossword.dart';
import 'package:mobile_games/pages/games_page/crossword/crossword_instructions.dart';

class CrosswordGamePage extends StatelessWidget {
  const CrosswordGamePage({super.key});

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
        title:
            const Text('Crossword Game', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // Action for settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Placeholder for the favorite game image or content
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 150,
            color: Colors.grey[300],
            child: const Center(
              child: Text(
                'Game (Image/Info)',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Tab buttons for Game, Rank, and How to play
          const TabButtons(),
          const SizedBox(height: 20),
          // Create a private game and Fast game buttons
          CustomButton(
            text: 'Create a private game',
            onPressed: () {
              // Action for creating a private game
              if (kDebugMode) {
                print('Create a private game pressed');
              }
            },
          ),
          const SizedBox(height: 10),
          CustomButton(
            text: 'Fast game',
            onPressed: () {
              // open the crossword game
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CrosswordGame(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Widget for Tab Buttons (Game, Rank, How to play)
class TabButtons extends StatelessWidget {
  const TabButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            // Handle Game tab tap
            if (kDebugMode) {
              print('Game tab pressed');
            }
          },
          child: const Text('Game', style: TextStyle(fontSize: 18)),
        ),
        const VerticalDivider(thickness: 2, color: Colors.black),
        GestureDetector(
          onTap: () {
            // Handle Rank tab tap
            if (kDebugMode) {
              print('Rank tab pressed');
            }
          },
          child: const Text('Rank', style: TextStyle(fontSize: 18)),
        ),
        const VerticalDivider(thickness: 2, color: Colors.black),
        GestureDetector(
          onTap: () {
            // Handle How to play tab tap
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CrosswordInstructions(),
              ),
            );
          },
          child: const Text('How to play', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}

// Custom button widget
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple[100], // Background color for the button
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
