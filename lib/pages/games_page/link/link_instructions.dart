import 'package:flutter/material.dart';

class LinkInstructions extends StatelessWidget {
  const LinkInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Play Link'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'How to Play Link',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '1. Objective:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   The objective of the Link game is to match the emotion with the correct emoji.',
              ),
              SizedBox(height: 16),
              Text(
                '2. How to Play:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   - Drag and drop the emotion to the corresponding emoji.',
              ),
              Text(
                '   - If the match is correct, the items will be linked and removed from the board.',
              ),
              Text(
                '   - If the match is incorrect, try again until you find the correct match.',
              ),
              SizedBox(height: 16),
              Text(
                '3. Tips:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   - Start with the emotions you are most confident about.',
              ),
              Text(
                '   - Use the process of elimination to help find the correct matches.',
              ),
              Text(
                '   - Pay attention to the visual cues provided by the game.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Winning the Game:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   - The game is won when all emotions are correctly matched with their corresponding emojis.',
              ),
              Text(
                '   - You can check your progress at any time to see how many matches you have completed.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
