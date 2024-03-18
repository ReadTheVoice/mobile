import 'package:flutter/material.dart';

class ArchivedMeetingsScreen extends StatefulWidget {
  const ArchivedMeetingsScreen({super.key});

  @override
  State<ArchivedMeetingsScreen> createState() => _ArchivedMeetingsScreenState();
}

class _ArchivedMeetingsScreenState extends State<ArchivedMeetingsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  Placeholder(
      child: Text("Archived meetings"),
    )
    );
  }
}
