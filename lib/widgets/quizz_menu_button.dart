import 'package:flutter/material.dart';

class QuizzMenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  @override
  const QuizzMenuButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 75,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 32)),
      ),
    );
  }
}
