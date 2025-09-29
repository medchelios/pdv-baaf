import 'package:flutter/material.dart';

class AuthSubtitle extends StatelessWidget {
  final String text;
  const AuthSubtitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF6B7280),
        fontSize: 13,
      ),
      textAlign: TextAlign.center,
    );
  }
}
