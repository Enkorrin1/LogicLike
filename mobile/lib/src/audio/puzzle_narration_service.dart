import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Keeps puzzle narration deliberate and child-friendly across platforms.
///
/// Speech engines belong to the device. We keep the child's configured default
/// voice unless the system explicitly exposes a higher-quality alternative.
class PuzzleNarrationService {
  PuzzleNarrationService({FlutterTts? tts}) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;
  bool _isSpeaking = false;

  bool get isSpeaking => _isSpeaking;

  Future<void> speak(String text, Locale locale) async {
    final language = _speechLocale(locale);

    try {
      await _tts.stop();
      await _tts.awaitSpeakCompletion(true);
      await _tts.setLanguage(language);
      // flutter_tts maps 0.5 to Android's natural 1.0 speech rate.
      await _tts.setSpeechRate(0.52);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      final preferredVoice = await _preferredHighQualityVoice(language);
      if (preferredVoice != null) {
        await _tts.setVoice(preferredVoice);
      }

      _isSpeaking = true;
      await _tts.speak(text, focus: true);
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'puzzle narration',
          context: ErrorDescription('speaking a puzzle prompt'),
        ),
      );
    } finally {
      _isSpeaking = false;
    }
  }

  Future<void> stop() async {
    await _tts.stop();
    _isSpeaking = false;
  }

  Future<Map<String, String>?> _preferredHighQualityVoice(
    String requestedLocale,
  ) async {
    final voices = await _tts.getVoices;
    return PuzzleNarrationVoicePolicy.choose(voices, requestedLocale);
  }

  String _speechLocale(Locale locale) {
    const preferredRegions = <String, String>{
      'ar': 'ar-SA',
      'de': 'de-DE',
      'en': 'en-US',
      'es': 'es-ES',
      'fr': 'fr-FR',
      'hi': 'hi-IN',
      'it': 'it-IT',
      'ja': 'ja-JP',
      'ko': 'ko-KR',
      'pt': 'pt-BR',
      'ru': 'ru-RU',
      'zh': 'zh-CN',
    };
    return preferredRegions[locale.languageCode] ?? locale.toLanguageTag();
  }
}

/// Selects a voice only when Android/iOS describes it as a meaningful quality
/// upgrade. A standard voice is deliberately left alone: the device default is
/// often the family-selected voice and is more predictable than an arbitrary
/// matching locale from the engine's voice list.
class PuzzleNarrationVoicePolicy {
  const PuzzleNarrationVoicePolicy._();

  static Map<String, String>? choose(
    dynamic voices,
    String requestedLocale,
  ) {
    if (voices is! Iterable) {
      return null;
    }

    final requestedLanguage = requestedLocale.split('-').first.toLowerCase();
    final candidates = voices
        .whereType<Map>()
        .map(_normaliseVoice)
        .whereType<Map<String, String>>()
        .where(
          (voice) =>
              _isInstalled(voice) &&
              _matchesLocale(
                  voice['locale']!, requestedLocale, requestedLanguage) &&
              _isHighQuality(voice),
        )
        .toList()
      ..sort((left, right) => _score(right).compareTo(_score(left)));

    if (candidates.isEmpty) {
      return null;
    }

    final best = candidates.first;
    return {'name': best['name']!, 'locale': best['locale']!};
  }

  static Map<String, String>? _normaliseVoice(Map voice) {
    final name = voice['name']?.toString();
    final locale = voice['locale']?.toString();
    if (name == null || name.isEmpty || locale == null || locale.isEmpty) {
      return null;
    }

    return {
      'name': name,
      'locale': locale,
      'quality': voice['quality']?.toString().toLowerCase() ?? '',
      'latency': voice['latency']?.toString().toLowerCase() ?? '',
      'networkRequired':
          voice['network_required']?.toString().toLowerCase() ?? '',
      'features': voice['features']?.toString().toLowerCase() ?? '',
    };
  }

  static bool _isInstalled(Map<String, String> voice) =>
      !voice['features']!.contains('notinstalled');

  static bool _matchesLocale(
    String locale,
    String requestedLocale,
    String requestedLanguage,
  ) {
    final normalized = locale.toLowerCase();
    return normalized == requestedLocale.toLowerCase() ||
        normalized.startsWith('$requestedLanguage-');
  }

  static bool _isHighQuality(Map<String, String> voice) {
    final quality = voice['quality']!;
    final name = voice['name']!.toLowerCase();
    return quality == 'high' ||
        quality == 'very high' ||
        name.contains('natural') ||
        name.contains('neural') ||
        name.contains('premium') ||
        name.contains('enhanced');
  }

  static int _score(Map<String, String> voice) {
    final quality = voice['quality']!;
    final name = voice['name']!.toLowerCase();
    final isNetworkVoice =
        voice['networkRequired'] == 'true' || voice['networkRequired'] == '1';
    final qualityScore = switch (quality) {
      'very high' => 600,
      'high' => 400,
      _ => 0,
    };
    final naturalScore = name.contains('natural') || name.contains('neural')
        ? 800
        : name.contains('premium') || name.contains('enhanced')
            ? 600
            : 0;
    final latencyScore = switch (voice['latency']) {
      'very low' => 80,
      'low' => 50,
      'normal' => 20,
      _ => 0,
    };

    // A network voice is allowed only after quality checks above; it can be
    // substantially more natural, while the default voice remains the fallback.
    return qualityScore +
        naturalScore +
        latencyScore +
        (isNetworkVoice ? 15 : 30);
  }
}
