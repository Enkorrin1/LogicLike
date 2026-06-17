import 'dart:io';

Future<void> main(List<String> args) async {
  final buildDebug = args.contains('--build-debug');
  final buildRelease = args.contains('--build-release');
  final steps = <_QaStep>[
    _QaStep('Localization audit', Platform.resolvedExecutable, [
      'run',
      'tool/localization_audit.dart',
    ]),
    _QaStep('Content audit', Platform.resolvedExecutable, [
      'run',
      'tool/content_audit.dart',
    ]),
    _QaStep('Flutter analyze', _flutterExecutable(), ['analyze']),
    _QaStep('Flutter tests', _flutterExecutable(), ['test']),
    if (buildDebug)
      _QaStep('Debug APK build', _flutterExecutable(), [
        'build',
        'apk',
        '--debug',
      ]),
    if (buildRelease)
      _QaStep('Release APK build', _flutterExecutable(), [
        'build',
        'apk',
        '--release',
      ]),
  ];

  for (final step in steps) {
    stdout.writeln('\n== ${step.name} ==');
    final result = await Process.run(
      step.executable,
      step.arguments,
      runInShell: Platform.isWindows,
    );
    stdout.write(result.stdout);
    stderr.write(result.stderr);

    if (result.exitCode != 0) {
      stderr.writeln('${step.name} failed with exit code ${result.exitCode}.');
      exitCode = result.exitCode;
      return;
    }
  }

  stdout.writeln('\nRelease QA passed.');
}

String _flutterExecutable() {
  final explicit = Platform.environment['FLUTTER_BIN'];
  if (explicit != null && explicit.isNotEmpty) {
    return explicit;
  }

  const localWindowsFlutter = r'D:\Program Files\flutter\bin\flutter.bat';
  if (Platform.isWindows && File(localWindowsFlutter).existsSync()) {
    return localWindowsFlutter;
  }

  return Platform.isWindows ? 'flutter.bat' : 'flutter';
}

class _QaStep {
  const _QaStep(this.name, this.executable, this.arguments);

  final String name;
  final String executable;
  final List<String> arguments;
}
