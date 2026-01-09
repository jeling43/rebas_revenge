# Reba's Revenge 🐕🎾

A magical world platformer game built with Flutter featuring Reba the golden retriever on a rescue mission!

## Game Overview

**Reba's Revenge** is a side-scrolling platformer where you play as Reba, a brave golden retriever who must rescue her friends Margo and Millie from evil magical squirrels in a whimsical fantasy world.

## Features

- 🐕 **Play as Reba** - Control a golden retriever character with smooth movement and jumping mechanics
- 🎾 **Collect Tennis Balls** - Gather magical glowing tennis balls throughout the level
- 🐿️ **Avoid Evil Squirrels** - Dodge dangerous magical squirrels that patrol the platforms
- 🏆 **Rescue Friends** - Find and free Margo and Millie trapped in cages
- ✨ **Magical Theme** - Colorful, whimsical environment with sparkle effects
- 🎮 **Multiple Game States** - Main menu, gameplay, game over, and victory screens

## How to Play

### Controls
- **Arrow Keys** or **WASD** - Move left and right
- **SPACE** or **UP Arrow** or **W** - Jump
- **Mouse/Touch** - Navigate menus

### Objective
1. Navigate through the magical platformer level
2. Collect at least 5 magical tennis balls
3. Rescue both Margo and Millie from their cages
4. Avoid touching the evil red squirrels (instant game over!)

### Victory Condition
Successfully rescue both friends AND collect enough tennis balls to win!

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
│   ├── menu_screen.dart              # Main menu UI
│   └── game_screen.dart              # Game screen with HUD and overlays
└── game/
    ├── game_world.dart               # Main game logic and world
    └── components/
        ├── player.dart               # Reba character component
        ├── enemy.dart                # Evil squirrel enemies
        ├── collectible.dart          # Tennis ball collectibles
        ├── friend.dart               # Margo and Millie characters
        └── platform.dart             # Platform components
```

## Technical Details

- **Framework**: Flutter
- **Game Engine**: Flame 1.19.0
- **Platform Support**: Web, Windows, macOS, Linux, Android, iOS
- **Architecture**: Component-based game architecture with collision detection
- **Rendering**: Custom Canvas rendering with magical effects and animations

## Game Features Implementation

### Physics
- Gravity system for realistic jumping
- Platform collision detection
- Smooth horizontal movement

### Visual Effects
- Sparkle and glow effects on magical elements
- Animated floating collectibles
- Color gradients for magical atmosphere
- Character animations

### Game States
- **Playing**: Active gameplay with movement and collision
- **Game Over**: Triggered when touching a squirrel
- **Victory**: Achieved when all objectives are completed

## Development

This project uses Flutter and the Flame game engine for cross-platform game development. The game is designed with:

- Clean component-based architecture
- Separation of concerns (game logic, UI, components)
- Reusable game components
- Responsive design for multiple screen sizes

## Credits

Created for the magical adventures of Reba, Margo, and Millie! 🐕✨

## License

This project is a private Flutter application.
