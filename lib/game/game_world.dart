import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'components/player.dart';
import 'components/platform.dart';
import 'components/enemy.dart';
import 'components/collectible.dart';
import 'components/friend.dart';

enum GameState {
  playing,
  gameOver,
  victory,
}

class RebasRevengeGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents {
  late Player player;
  GameState gameState = GameState.playing;
  int tennisballsCollected = 0;
  int friendsRescued = 0;
  final int tennisballsNeeded = 5;
  final int friendsTotal = 2;
  
  final Set<LogicalKeyboardKey> _pressedKeys = {};

  @override
  Color backgroundColor() => const Color(0xFF1a0033);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add camera
    camera.viewfinder.anchor = Anchor.topLeft;
    
    // Create player
    player = Player(position: Vector2(100, 300));
    await add(player);
    
    // Create platforms
    await _createPlatforms();
    
    // Create enemies (squirrels)
    await _createEnemies();
    
    // Create collectibles (tennis balls)
    await _createCollectibles();
    
    // Create friends (Margo and Millie)
    await _createFriends();
  }

  Future<void> _createPlatforms() async {
    // Ground platform
    await add(PlatformComponent(
      position: Vector2(0, size.y - 50),
      size: Vector2(size.x * 3, 50),
    ));
    
    // Floating platforms
    final platforms = [
      Vector2(200, 450),
      Vector2(400, 350),
      Vector2(600, 250),
      Vector2(800, 350),
      Vector2(1000, 450),
      Vector2(1200, 350),
      Vector2(1400, 250),
      Vector2(1600, 350),
      Vector2(1800, 450),
      Vector2(2000, 300),
    ];
    
    for (final pos in platforms) {
      await add(PlatformComponent(
        position: pos,
        size: Vector2(150, 20),
      ));
    }
  }

  Future<void> _createEnemies() async {
    // Place squirrels on various platforms
    final enemyPositions = [
      Vector2(450, 320),
      Vector2(850, 320),
      Vector2(1250, 320),
      Vector2(1650, 320),
    ];
    
    for (final pos in enemyPositions) {
      await add(Enemy(position: pos));
    }
  }

  Future<void> _createCollectibles() async {
    // Place tennis balls throughout the level
    final collectiblePositions = [
      Vector2(300, 400),
      Vector2(500, 300),
      Vector2(700, 200),
      Vector2(900, 300),
      Vector2(1100, 400),
      Vector2(1300, 300),
      Vector2(1500, 200),
      Vector2(1700, 300),
    ];
    
    for (final pos in collectiblePositions) {
      await add(Collectible(position: pos));
    }
  }

  Future<void> _createFriends() async {
    // Place Margo and Millie at different locations
    await add(Friend(
      position: Vector2(1300, 250),
      name: 'Margo',
    ));
    
    await add(Friend(
      position: Vector2(2050, 200),
      name: 'Millie',
    ));
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    _pressedKeys.clear();
    _pressedKeys.addAll(keysPressed);
    
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space ||
          event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.keyW) {
        player.jump();
      }
    }
    
    return KeyEventResult.handled;
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (gameState != GameState.playing) return;
    
    // Handle horizontal movement
    double horizontalMovement = 0;
    
    if (_pressedKeys.contains(LogicalKeyboardKey.arrowLeft) ||
        _pressedKeys.contains(LogicalKeyboardKey.keyA)) {
      horizontalMovement = -1;
    } else if (_pressedKeys.contains(LogicalKeyboardKey.arrowRight) ||
        _pressedKeys.contains(LogicalKeyboardKey.keyD)) {
      horizontalMovement = 1;
    }
    
    player.horizontalMovement = horizontalMovement;
    
    // Camera follows player
    final playerX = player.position.x;
    final cameraX = camera.viewfinder.position.x;
    final screenWidth = size.x;
    
    // Keep player in center-ish of screen
    if (playerX > screenWidth / 2) {
      camera.viewfinder.position.x = playerX - screenWidth / 2;
    }
  }

  void collectTennisball() {
    tennisballsCollected++;
    checkVictory();
  }

  void rescueFriend() {
    friendsRescued++;
    checkVictory();
  }

  void checkVictory() {
    if (friendsRescued >= friendsTotal && tennisballsCollected >= tennisballsNeeded) {
      gameState = GameState.victory;
    }
  }

  void gameOver() {
    gameState = GameState.gameOver;
  }

  void resetGame() {
    gameState = GameState.playing;
    tennisballsCollected = 0;
    friendsRescued = 0;
    
    // Reset player position
    player.position = Vector2(100, 300);
    player.velocity = Vector2.zero();
    
    // Reset camera
    camera.viewfinder.position = Vector2.zero();
    
    // Remove and recreate all game objects
    for (final enemy in children.whereType<Enemy>()) {
      enemy.removeFromParent();
    }
    for (final collectible in children.whereType<Collectible>()) {
      collectible.removeFromParent();
    }
    for (final friend in children.whereType<Friend>()) {
      friend.removeFromParent();
    }
    
    _createEnemies();
    _createCollectibles();
    _createFriends();
  }
}
