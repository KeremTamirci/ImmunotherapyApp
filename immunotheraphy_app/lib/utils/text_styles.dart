// lib/text_styles.dart

import 'package:flutter/material.dart';

class AlertTitleText extends StatelessWidget {
  final String text;
  final Color? color;

  // Use a positional parameter for text
  const AlertTitleText(
    this.text, {
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: color ?? Colors.black, // Default color is black
      ),
    );
  }
}

class AlertText extends StatelessWidget {
  final String text;
  final Color? color;

  // Use a positional parameter for text
  const AlertText(
    this.text, {
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        color: color ?? Colors.black, // Default color is black
      ),
    );
  }
}

class AlertTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;

  const AlertTextButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 18)),
        foregroundColor: MaterialStatePropertyAll(
          textColor ?? Colors.blue, // Default color is blue
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class AlertElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const AlertElevatedButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Use the default ElevatedButton background color from the theme
    final defaultBackgroundColor = Theme.of(context).colorScheme.primary;
    const defaultTextColor = Colors.white;

    return ElevatedButton(
      style: ButtonStyle(
        textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 18)),
        backgroundColor: MaterialStatePropertyAll(
          backgroundColor ??
              defaultBackgroundColor, // Use default if no background color is specified
        ),
        foregroundColor: MaterialStatePropertyAll(
          textColor ??
              defaultTextColor, // Use default if no text color is specified
        ),
        minimumSize: const MaterialStatePropertyAll(Size(70, 50)),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
