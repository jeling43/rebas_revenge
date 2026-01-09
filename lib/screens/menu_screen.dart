import 'package:flutter/material.dart';
import 'game_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade900,
              Colors.blue.shade900,
              Colors.pink.shade900,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Game Title
              Text(
                "🐕 Reba's Revenge:\nRetriever Ridge Racing 🏁",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade300,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.purple.shade900,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              // Subtitle
              Text(
                'Race to Save Margo & Millie!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withOpacity(0.9),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              
              // Start Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GameScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade600,
                  foregroundColor: Colors.brown.shade900,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 20,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('START GAME'),
              ),
              const SizedBox(height: 40),
              
              // Instructions
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.purple.shade300,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'HOW TO PLAY',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade300,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInstruction('🏎️', 'Arrow Keys / WASD to steer'),
                    _buildInstruction('⚡', 'SPACE for speed boost'),
                    _buildInstruction('🎾', 'Collect tennis balls for power-ups'),
                    _buildInstruction('🏁', 'Finish first to win!'),
                    _buildInstruction('🐿️', 'Avoid squirrel racers!'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstruction(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
