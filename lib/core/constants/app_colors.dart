import 'package:flutter/material.dart';

final BoxDecoration boxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(32),
  gradient: const LinearGradient(
    colors: [Color(0xFF6A5AE0), Color(0xFF2DD4BF)],
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.deepPurpleAccent.withValues(alpha: 0.35),
      blurRadius: 18,
      offset: const Offset(0, 10),
    ),
  ],
);

enum EmailCheckResult { exists, notExists }
