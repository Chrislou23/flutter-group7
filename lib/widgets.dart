import 'package:flutter/material.dart';

// A custom button widget that wraps an ElevatedButton
class CustomButton extends StatelessWidget {
  // Text to display on the button
  final String text;
  // Callback function to execute when the button is pressed
  final VoidCallback onPressed;
  // Optional text style for customizing the button text
  final TextStyle? textStyle;

  // Constructor with required text and onPressed parameters
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // Set the callback function
      onPressed: onPressed,
      // Define the button's child widget
      child: Text(
        text,
        // Apply the provided text style or default to the theme's labelLarge style
        style: textStyle ?? Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
