import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_of_life/app/app.dart';

void main() {
  group('LocaleState', () {
    test('supports value comparison', () {
      expect(
        const LocaleState(locale: Locale('es')),
        const LocaleState(locale: Locale('es')),
      );
    });
  });
}
