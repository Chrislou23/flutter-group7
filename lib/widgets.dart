import 'package:flutter/material.dart';

// Widget for Tab Buttons (Game, Rank, How to play)
class TabButtons extends StatelessWidget {
  const TabButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            // Handle Game tab tap
            print('Game tab pressed');
          },
          child: const Text('Game', style: TextStyle(fontSize: 18)),
        ),
        const VerticalDivider(thickness: 2, color: Colors.black),
        GestureDetector(
          onTap: () {
            // Handle Rank tab tap
            print('Rank tab pressed');
          },
          child: const Text('Rank', style: TextStyle(fontSize: 18)),
        ),
        const VerticalDivider(thickness: 2, color: Colors.black),
        GestureDetector(
          onTap: () {
            // Handle How to play tab tap
            print('How to play tab pressed');
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