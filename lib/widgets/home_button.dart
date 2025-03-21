import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const HomeButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
