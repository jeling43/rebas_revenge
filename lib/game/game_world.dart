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
  final int friendsTotal = 2;
  
  // Racing-specific properties
  int currentLap = 1;
  final int totalLaps = 3;
  int playerPosition = 1; // 1st, 2nd, 3rd, etc.
  double raceTime = 0;
  double boostMeter = 100.0; // Start with full boost
  List<Enemy> opponents = [];
  int checkpointsPassed = 0;
  
  final Set<LogicalKeyboardKey> _pressedKeys = {};

  @override
  Color backgroundColor() => const Color(0xFF1a0033);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add camera - top-down view
    camera.viewfinder.anchor = Anchor.center;
    
    // Create player at starting position
    player = Player(position: Vector2(size.x / 2, size.y - 150));
    await add(player);
    
    // Create racing track
    await _createRacingTrack();
    
    // Create opponents (squirrel racers)
    await _createOpponents();
    
    // Create collectibles (tennis balls for boosts)
    await _createCollectibles();
    
    // Create checkpoints for lap counting
    await _createCheckpoints();
  }

  Future<void> _createRacingTrack() async {
    // Create oval racing track with platforms as track boundaries
    // Center of track
    final centerX = size.x / 2;
    final centerY = size.y / 2;
    final trackWidth = 400.0;
    final trackHeight = 600.0;
    
    // Outer track boundary (simplified oval using rectangles)
    // Top
    await add(PlatformComponent(
      position: Vector2(centerX - trackWidth / 2, centerY - trackHeight / 2),
      size: Vector2(trackWidth, 20),
    ));
    // Bottom
    await add(PlatformComponent(
      position: Vector2(centerX - trackWidth / 2, centerY + trackHeight / 2 - 20),
      size: Vector2(trackWidth, 20),
    ));
    // Left
    await add(PlatformComponent(
      position: Vector2(centerX - trackWidth / 2, centerY - trackHeight / 2),
      size: Vector2(20, trackHeight),
    ));
    // Right
    await add(PlatformComponent(
      position: Vector2(centerX + trackWidth / 2 - 20, centerY - trackHeight / 2),
      size: Vector2(20, trackHeight),
    ));
    
    // Inner track boundary (smaller oval)
    final innerWidth = 200.0;
    final innerHeight = 400.0;
    // Top
    await add(PlatformComponent(
      position: Vector2(centerX - innerWidth / 2, centerY - innerHeight / 2),
      size: Vector2(innerWidth, 20),
    ));
    // Bottom
    await add(PlatformComponent(
      position: Vector2(centerX - innerWidth / 2, centerY + innerHeight / 2 - 20),
      size: Vector2(innerWidth, 20),
    ));
    // Left
    await add(PlatformComponent(
      position: Vector2(centerX - innerWidth / 2, centerY - innerHeight / 2),
      size: Vector2(20, innerHeight),
    ));
    // Right
    await add(PlatformComponent(
      position: Vector2(centerX + innerWidth / 2 - 20, centerY - innerHeight / 2),
      size: Vector2(20, innerHeight),
    ));
    
    // Add decorative track elements (fire hydrants, bones, etc.)
    await _addTrackDecorations(centerX, centerY);
  }
  
  Future<void> _addTrackDecorations(double centerX, double centerY) async {
    // Add some themed decorations around the track
    // These will be simple colored markers for now
    final decorations = [
      Vector2(centerX - 250, centerY - 350),
      Vector2(centerX + 250, centerY - 350),
      Vector2(centerX - 250, centerY + 350),
      Vector2(centerX + 250, centerY + 350),
    ];
    
    for (final pos in decorations) {
      // Simple decoration marker (could be enhanced later)
      await add(PlatformComponent(
        position: pos,
        size: Vector2(30, 30),
      ));
    }
  }

  Future<void> _createCheckpoints() async {
    // Create invisible checkpoints for lap counting
    final centerX = size.x / 2;
    final centerY = size.y / 2;
    
    // Start/finish line checkpoint
    await add(Friend(
      position: Vector2(centerX, centerY + 300),
      name: 'Checkpoint',
    ));
  }

  Future<void> _createOpponents() async {
    // Create AI-controlled squirrel racers
    final centerX = size.x / 2;
    final centerY = size.y / 2;
    
    final opponentPositions = [
      Vector2(centerX - 50, centerY + 250),
      Vector2(centerX + 50, centerY + 250),
      Vector2(centerX, centerY + 200),
    ];
    
    for (final pos in opponentPositions) {
      final opponent = Enemy(position: pos);
      await add(opponent);
      opponents.add(opponent);
    }
  }

  Future<void> _createCollectibles() async {
    // Place tennis balls around the track for speed boosts
    final centerX = size.x / 2;
    final centerY = size.y / 2;
    
    final collectiblePositions = [
      Vector2(centerX - 300, centerY),
      Vector2(centerX + 300, centerY),
      Vector2(centerX, centerY - 250),
      Vector2(centerX, centerY + 250),
      Vector2(centerX - 200, centerY - 150),
      Vector2(centerX + 200, centerY - 150),
      Vector2(centerX - 200, centerY + 150),
      Vector2(centerX + 200, centerY + 150),
    ];
    
    for (final pos in collectiblePositions) {
      await add(Collectible(position: pos));
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    _pressedKeys.clear();
    _pressedKeys.addAll(keysPressed);
    
    // Boost activation with space bar
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space) {
        player.activateBoost();
      }
    }
    
    return KeyEventResult.handled;
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (gameState != GameState.playing) return;
    
    // Update race time
    raceTime += dt;
    
    // Regenerate boost meter slowly
    if (boostMeter < 100) {
      boostMeter = min(100, boostMeter + dt * 10);
    }
    
    // Handle racing controls
    double forwardMovement = 0;
    double steeringMovement = 0;
    
    if (_pressedKeys.contains(LogicalKeyboardKey.arrowUp) ||
        _pressedKeys.contains(LogicalKeyboardKey.keyW)) {
      forwardMovement = 1;
    } else if (_pressedKeys.contains(LogicalKeyboardKey.arrowDown) ||
        _pressedKeys.contains(LogicalKeyboardKey.keyS)) {
      forwardMovement = -1;
    }
    
    if (_pressedKeys.contains(LogicalKeyboardKey.arrowLeft) ||
        _pressedKeys.contains(LogicalKeyboardKey.keyA)) {
      steeringMovement = -1;
    } else if (_pressedKeys.contains(LogicalKeyboardKey.arrowRight) ||
        _pressedKeys.contains(LogicalKeyboardKey.keyD)) {
      steeringMovement = 1;
    }
    
    player.forwardMovement = forwardMovement;
    player.steeringMovement = steeringMovement;
    
    // Camera follows player
    camera.viewfinder.position = player.position;
    
    // Update opponent positions (simple AI)
    _updateOpponents(dt);
    
    // Calculate player position
    _calculateRacePosition();
  }
  
  void _updateOpponents(double dt) {
    // Simple AI: opponents move around the track
    for (final opponent in opponents) {
      // Move opponents in a circular pattern around the track
      final centerX = size.x / 2;
      final centerY = size.y / 2;
      final angle = opponent.aiAngle;
      final radius = 250.0;
      
      opponent.aiAngle += dt * 0.5; // Adjust speed
      opponent.position.x = centerX + cos(angle) * radius;
      opponent.position.y = centerY + sin(angle) * radius;
    }
  }
  
  void _calculateRacePosition() {
    // Simple position calculation based on progress
    // In a full implementation, this would be based on track progress
    playerPosition = 1; // Default to 1st place for now
    
    // Count how many opponents are ahead
    for (final opponent in opponents) {
      final opponentProgress = opponent.aiAngle;
      final playerProgress = currentLap * 2 * pi + atan2(
        player.position.y - size.y / 2,
        player.position.x - size.x / 2,
      );
      
      if (opponentProgress > playerProgress) {
        playerPosition++;
      }
    }
  }

  void collectTennisball() {
    tennisballsCollected++;
    // Tennis balls now give boost energy instead of counting toward victory
    boostMeter = min(100, boostMeter + 25);
  }

  void rescueFriend() {
    friendsRescued++;
  }
  
  void passCheckpoint() {
    checkpointsPassed++;
    
    // Every checkpoint passed = lap completed
    if (checkpointsPassed > 0 && checkpointsPassed % 1 == 0) {
      currentLap = min(totalLaps + 1, checkpointsPassed + 1);
      
      // Check victory condition
      if (currentLap > totalLaps && playerPosition == 1) {
        gameState = GameState.victory;
      }
    }
  }

  void checkVictory() {
    // Victory now based on completing laps in 1st place
    if (currentLap > totalLaps && playerPosition == 1) {
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
    currentLap = 1;
    raceTime = 0;
    boostMeter = 100.0;
    checkpointsPassed = 0;
    
    // Reset player position
    player.position = Vector2(size.x / 2, size.y - 150);
    player.velocity = Vector2.zero();
    player.rotation = 0;
    
    // Reset camera
    camera.viewfinder.position = player.position;
    
    // Remove and recreate all game objects
    for (final opponent in opponents) {
      opponent.removeFromParent();
    }
    opponents.clear();
    
    for (final collectible in children.whereType<Collectible>()) {
      collectible.removeFromParent();
    }
    for (final friend in children.whereType<Friend>()) {
      friend.removeFromParent();
    }
    
    _createOpponents();
    _createCollectibles();
    _createCheckpoints();
  }
  
  String getPositionString() {
    switch (playerPosition) {
      case 1:
        return '1st';
      case 2:
        return '2nd';
      case 3:
        return '3rd';
      default:
        return '${playerPosition}th';
    }
  }
  
  String getRaceTimeString() {
    final minutes = (raceTime ~/ 60).toString().padLeft(1, '0');
    final seconds = (raceTime % 60).toStringAsFixed(1).padLeft(4, '0');
    return '$minutes:$seconds';
  }
}
