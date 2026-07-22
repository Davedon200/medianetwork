import 'package:flutter/material.dart';

class WebButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Decoration decoration;
  final String bodytext;
  final Color textColor;

  const WebButton({
    super.key,
    this.onPressed,
    required this.decoration,
    required this.textColor,
    this.bodytext = 'Get Started',
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 16),
          decoration: decoration,
          child: Text(
            bodytext,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
