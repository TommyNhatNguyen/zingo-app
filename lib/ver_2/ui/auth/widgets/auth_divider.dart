import 'package:flutter/material.dart';
import 'package:zingo/l10n/l10n.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        const Expanded(child: Divider()),
        Text(context.l10n.orGetStartedWith),
        const Expanded(child: Divider()),
      ],
    );
  }
}
