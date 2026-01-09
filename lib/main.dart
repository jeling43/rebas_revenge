import 'package:flutter/material.dart';
import 'screens/menu_screen.dart';

void main() {
  runApp(const RebasRevengeApp());
}

class RebasRevengeApp extends StatelessWidget {
  const RebasRevengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Reba's Revenge: Retriever Ridge Racing",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
