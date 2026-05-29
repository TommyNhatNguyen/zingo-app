import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RegisterInfo extends StatelessWidget {
  const RegisterInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SvgPicture.asset(
            "assets/logo_zingo.svg",
            width: 100,
            height: 100,
          ),
        ),
        Center(
          child: Column(
            children: [
              Text(
                "Create an account",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 200,
                child: Text(
                  "Let's start using Zingo and boost your english skills with bite size dialogs",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
