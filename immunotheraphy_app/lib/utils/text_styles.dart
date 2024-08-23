// lib/text_styles.dart

import 'package:flutter/material.dart';

class DialogTitleText extends StatelessWidget {
  final String text;
  final Color? color;

  // Use a positional parameter for text
  const DialogTitleText(
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

class DialogText extends StatelessWidget {
  final String text;
  final Color? color;

  // Use a positional parameter for text
  const DialogText(
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

class DialogTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;

  const DialogTextButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 16)),
        foregroundColor: MaterialStatePropertyAll(
          textColor ?? const Color(0xff1a80e5), // Default color is blue
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class DialogElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const DialogElevatedButton(
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
        textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 16)),
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

class MainTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;

  const MainTextButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: TextButton(
        style: ButtonStyle(
          textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 16)),
          foregroundColor: MaterialStatePropertyAll(
            textColor ?? const Color(0xff1a80e5), // Default color is blue
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

class MainElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? widthFactor;

  const MainElevatedButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.widthFactor,
  });

  @override
  Widget build(BuildContext context) {
    // Use the default ElevatedButton background color from the theme
    final defaultBackgroundColor = Theme.of(context).colorScheme.primary;
    const defaultTextColor = Colors.white;

    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      // Remove this FractionallySizedBox if you want to make the buttons same as before
      child: FractionallySizedBox(
        widthFactor: widthFactor ?? 1,
        child: ElevatedButton(
          style: ButtonStyle(
            textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 16)),
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
        ),
      ),
    );
  }
}
