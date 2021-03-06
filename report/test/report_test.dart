import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:report/report.dart';

void main() {
  const MethodChannel channel = MethodChannel('report');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Report.platformVersion, '42');
  });
}
