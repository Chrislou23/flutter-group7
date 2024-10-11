import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_games/timer_provider.dart';
import 'package:mobile_games/pages/games_page/crossword/crossword.dart';
import 'package:mobile_games/pages/games_page/link/link_instructions_en.dart';
import 'package:mobile_games/pages/games_page/link/link_instructions_fi.dart';
import 'package:mobile_games/pages/games_page/crossword/crossword_instructions_en.dart';
import 'package:mobile_games/pages/games_page/crossword/crossword_instructions_fi.dart';
import 'package:mobile_games/widgets.dart';

class CrosswordGamePage extends StatefulWidget {
  const CrosswordGamePage({super.key});

  @override
  _CrosswordGamePageState createState() => _CrosswordGamePageState();
}

class _CrosswordGamePageState extends State<CrosswordGamePage> {
  bool isEnglish = true;

  void toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timerProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context); // Navigate back to previous page
              },
            ),
            title: timerProvider.isBlocked
                ? Text(
                    "Blocked: ${_formatDuration(timerProvider.remainingBlockTime)}",
                    style: const TextStyle(color: Colors.black),
                  )
                : const Text('Crossword Game', style: TextStyle(color: Colors.black)),
            centerTitle: true,
            actions: [
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
              : Column(
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
                    // Tab buttons for Game, Rank, How to play, and Language toggle
                    TabButtons(isEnglish: isEnglish, toggleLanguage: toggleLanguage),
                    const SizedBox(height: 20),
                    // Create a private game and Fast game buttons
                    CustomButton(
                      text: 'Create a private game',
                      onPressed: () {
                        if (kDebugMode) {
                          print('Create a private game pressed');
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      text: 'Fast game',
                      onPressed: () {
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
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Widget for Tab Buttons (Game, Rank, How to play, Language toggle)
class TabButtons extends StatelessWidget {
  final bool isEnglish;
  final VoidCallback toggleLanguage;

  const TabButtons({super.key, required this.isEnglish, required this.toggleLanguage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            if (kDebugMode) {
              print('Game tab pressed');
            }
          },
          child: const Text('Game', style: TextStyle(fontSize: 18)),
        ),
        const VerticalDivider(thickness: 2, color: Colors.black),
        GestureDetector(
          onTap: () {
            if (kDebugMode) {
              print('Rank tab pressed');
            }
          },
          child: const Text('Rank', style: TextStyle(fontSize: 18)),
        ),
        const VerticalDivider(thickness: 2, color: Colors.black),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => isEnglish
                    ? const CrosswordInstructionsEn()
                    : const CrosswordInstructionsFi(),
              ),
            );
          },
          child: const Text('How to play', style: TextStyle(fontSize: 18)),
        ),
        const VerticalDivider(thickness: 2, color: Colors.black),
        GestureDetector(
          onTap: toggleLanguage,
          child: Text(
            isEnglish ? 'Switch to Finnish' : 'Switch to English',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}