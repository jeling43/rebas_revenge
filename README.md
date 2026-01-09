# Reba's Revenge: Retriever Ridge Racing 🐕🎾🏁

A Mario Kart-style racing game built with Flutter featuring Reba the golden retriever racing to save her friends!

## Game Overview

**Reba's Revenge: Retriever Ridge Racing** is a top-down racing game where you play as Reba, a brave golden retriever who must race against evil squirrel opponents at Retriever Ridge to save her friends Margo and Millie.

## Features

- 🏎️ **Race as Reba** - Control Reba in her racing kart with smooth steering and speed mechanics
- 🎾 **Collect Tennis Balls** - Gather tennis balls for speed boost power-ups
- 🐿️ **Compete Against Squirrels** - Race against AI-controlled squirrel opponents
- 🏁 **Complete 3 Laps** - Race around the Retriever Ridge track to victory
- ⚡ **Speed Boost System** - Use collected tennis balls to activate speed boosts
- 🏆 **Position Tracking** - See your current race position in real-time
- ✨ **Colorful Theme** - Fun, whimsical racing environment
- 🎮 **Multiple Game States** - Main menu, racing gameplay, game over, and victory screens

## How to Play

### Controls
- **Arrow Keys** or **WASD** - Steer your kart (forward/back/left/right)
- **SPACE** - Activate speed boost (uses boost meter)
- **Mouse/Touch** - Navigate menus

### Objective
1. Race around the Retriever Ridge track
2. Collect tennis balls for speed boost power-ups
3. Complete 3 laps around the track
4. Finish in 1st place to win and save Margo & Millie!

### Victory Condition
Successfully complete 3 laps and finish in 1st place to win the race!

## Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK (included with Flutter)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/jeling43/rebas_revenge.git
cd rebas_revenge
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the game:
```bash
# For web
flutter run -d chrome

# For desktop
flutter run -d windows  # or macos, linux

# For mobile
flutter run  # with device connected
```

### Building for Production

```bash
# Web
flutter build web

# Desktop
flutter build windows  # or macos, linux

# Mobile
flutter build apk      # Android
flutter build ios      # iOS
```

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── screens/
│   ├── menu_screen.dart              # Main menu UI with racing theme
│   └── game_screen.dart              # Game screen with racing HUD and overlays
└── game/
    ├── game_world.dart               # Main racing game logic and world
    └── components/
        ├── player.dart               # Reba's racing kart component
        ├── enemy.dart                # Squirrel racer opponents with AI
        ├── collectible.dart          # Tennis ball power-ups
        ├── friend.dart               # Checkpoint markers (Margo & Millie)
        └── platform.dart             # Track boundary components
```

## Technical Details

- **Framework**: Flutter
- **Game Engine**: Flame 1.19.0
- **Platform Support**: Web, Windows, macOS, Linux, Android, iOS
- **Architecture**: Component-based racing game architecture with collision detection
- **Rendering**: Custom Canvas rendering with top-down racing view

## Game Features Implementation

### Racing Mechanics
- Top-down racing view with camera following player
- Forward/backward acceleration and deceleration
- Steering and rotation system
- Speed boost activation with boost meter

### AI System
- Opponent racers move around the track
- Position tracking and race standings
- Lap counter system

### Visual Effects
- Speed boost visual effects
- Racing kart designs for player and opponents
- Track boundaries and decorations
- Real-time HUD with lap count, position, time, and boost meter

## Development

This project uses Flutter and the Flame game engine for cross-platform racing game development. The game is designed with:

- Clean component-based architecture
- Separation of concerns (game logic, UI, components)
- Reusable racing components
- Top-down racing camera system
- Responsive design for multiple screen sizes

## Game States

- **Playing**: Active racing gameplay with steering, acceleration, and boost mechanics
- **Game Over**: Triggered when finishing too far behind or crashing
- **Victory**: Achieved by completing 3 laps in 1st place

## Credits

Created for the magical adventures of Reba, Margo, and Millie! 🐕✨

## License

This project is a private Flutter application.
