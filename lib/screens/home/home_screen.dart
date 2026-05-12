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
                context.push("/profile");
              },
              child: Text('Profile'),
            ),
          ),
        ],
      ),
    );
  }
}
