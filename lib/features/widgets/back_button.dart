import 'package:flutter/material.dart';

class Baxkbutton extends StatelessWidget {
  const Baxkbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back_ios_new),
      alignment: Alignment.center,
    );
  }
}
