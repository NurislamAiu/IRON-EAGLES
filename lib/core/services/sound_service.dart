import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playClick() async {
    await _player.play(AssetSource('sounds/click.mp3'));
  }

  static Future<void> playSuccess() async {
    await _player.play(AssetSource('sounds/success.mp3'));
  }

  static Future<void> playAchievement() async {
    await _player.play(AssetSource('sounds/achievement.mp3'));
  }
}
