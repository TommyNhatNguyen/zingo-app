import 'package:flutter/material.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        const Expanded(child: Divider()),
        Text("Or get started with"),
        const Expanded(child: Divider()),
      ],
    );
  }
}
