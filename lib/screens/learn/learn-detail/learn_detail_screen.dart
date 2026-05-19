import 'package:flutter/material.dart';

class LearnDetailScreen extends StatelessWidget {
  final String id;

  const LearnDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dialog Detail")),
      body: Container(child: Text("id: $id")),
    );
  }
}
