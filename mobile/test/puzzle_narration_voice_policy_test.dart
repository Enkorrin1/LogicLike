import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/audio/puzzle_narration_service.dart';

void main() {
  group('PuzzleNarrationVoicePolicy', () {
    test('keeps the device default when only ordinary voices are available',
        () {
      final voice = PuzzleNarrationVoicePolicy.choose([
        {
          'name': 'ru-ru-x-ruf-local',
          'locale': 'ru-RU',
          'quality': 'normal',
          'latency': 'low',
          'network_required': '0',
          'features': '',
        },
      ], 'ru-RU');

      expect(voice, isNull);
    });

    test('prefers a high-quality matching voice over a generic one', () {
      final voice = PuzzleNarrationVoicePolicy.choose([
        {
          'name': 'ru-ru-x-ruf-local',
          'locale': 'ru-RU',
          'quality': 'normal',
          'latency': 'low',
          'network_required': '0',
          'features': '',
        },
        {
          'name': 'ru-ru-x-ruf-network',
          'locale': 'ru-RU',
          'quality': 'very high',
          'latency': 'normal',
          'network_required': '1',
          'features': '',
        },
      ], 'ru-RU');

      expect(voice, {
        'name': 'ru-ru-x-ruf-network',
        'locale': 'ru-RU',
      });
    });

    test('never selects an unavailable voice', () {
      final voice = PuzzleNarrationVoicePolicy.choose([
        {
          'name': 'en-us-natural',
          'locale': 'en-US',
          'quality': 'very high',
          'latency': 'low',
          'network_required': '1',
          'features': 'notInstalled',
        },
      ], 'en-US');

      expect(voice, isNull);
    });
  });
}
