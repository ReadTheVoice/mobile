import 'package:flutter/material.dart';

class FavoriteMeetingsScreen extends StatefulWidget {
  const FavoriteMeetingsScreen({super.key});

  @override
  State<FavoriteMeetingsScreen> createState() => _FavoriteMeetingsScreenState();
}

class _FavoriteMeetingsScreenState extends State<FavoriteMeetingsScreen> {
  /*
  Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QrCodeScreen(),
              ),
            );
   */

  @override
  Widget build(BuildContext context) {
    return const Text("Favorite meetings");
  }
}
