import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('content audit is a passing release gate', () async {
    final dartExecutable =
        Platform.isWindows ? r'D:\Program Files\flutter\bin\dart.bat' : 'dart';
    final result = await Process.run(
      dartExecutable,
      ['run', 'tool/content_audit.dart'],
      workingDirectory: Directory.current.path,
    );

    expect(result.exitCode, 0, reason: '${result.stdout}\n${result.stderr}');

    final auditFile = File('../CONTENT_AUDIT.json');
    final audit =
        jsonDecode(auditFile.readAsStringSync()) as Map<String, Object?>;
    final releaseGate = audit['releaseGate']! as Map<String, Object?>;
    final summary = audit['summary']! as Map<String, Object?>;

    expect(releaseGate['passed'], isTrue);
    expect(releaseGate['issues'], isEmpty);
    expect(summary['releaseGatePassed'], isTrue);
    expect(summary['releaseGateIssues'], 0);
  }, timeout: const Timeout(Duration(seconds: 90)));
}
