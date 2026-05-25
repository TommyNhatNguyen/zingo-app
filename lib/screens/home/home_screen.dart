import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 52,
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                context.push("/login");
              },
              child: Text('Login'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                context.push("/onboarding");
              },
              child: Text('Onboarding'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                context.push("/splash");
              },
              child: Text('Splash'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                context.push("/profile");
              },
              child: Text('Profile'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                context.push("/learn");
              },
              child: Text('Learn'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                context.push(
                  "/practice",
                  extra: {
                    "practice_session_id":
                        "1c11f53a-d653-4e1d-97e2-242e82ebe22b",
                    "dialog_id": "13febbdf-a74c-4904-bc3b-c22bdec6a327",
                  },
                );
              },
              child: Text('Practice'),
            ),
          ),
        ],
      ),
    );
  }
}
