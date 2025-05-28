import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final _player = AudioPlayer();

  static Future<void> playButton() async {
    await _play('sounds/button.mp3');
  }

  static Future<void> playLoading() async {
    await _play('sounds/loading.mp3');
  }

  static Future<void> playSuccess() async {
    await _play('sounds/success.mp3');
  }

  static Future<void> playWarning() async {
    await _play('sounds/warning.mp3');
  }

  static Future<void> _play(String path) async {
    try {
      await _player.stop(); // evita solapamiento
      await _player.play(AssetSource(path));
    } catch (_) {}
  }
}
