import 'dart:math';

String generateArtifactId() {
  final random = Random();
  return List.generate(8, (_) => random.nextInt(10)).join();
}
