import 'package:flutter/material.dart';

class CrosswordInstructionsEn extends StatelessWidget {
  const CrosswordInstructionsEn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Play Crossword'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'How to Play Crossword',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '1. Objective:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   The objective of the crossword puzzle is to fill the white squares with letters, forming words or phrases, by solving clues which lead to the answers.',
              ),
              SizedBox(height: 16),
              Text(
                '2. How to Play:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   - Click on a clue to highlight the corresponding word in the grid.',
              ),
              Text(
                '   - Type your answer using the keyboard. The letters will appear in the highlighted squares.',
              ),
              Text(
                '   - If you make a mistake, you can erase a letter by clicking on it and pressing the backspace key.',
              ),
              SizedBox(height: 16),
              Text(
                '3. Tips:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   - Start with the clues you know and fill in the easier answers first.',
              ),
              Text(
                '   - Use the filled-in letters to help solve the more difficult clues.',
              ),
              Text(
                '   - Check your answers as you go to ensure they fit with the other words in the grid.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Winning the Game:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   - The game is won when all the white squares are filled with the correct letters.',
              ),
              Text(
                '   - You can check your answers at any time to see if you have completed the puzzle correctly.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
