import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:game_of_life/app/app.dart';
import 'package:test/test.dart';

void main() {
  group('LocaleCubit', () {
    blocTest<LocaleCubit, LocaleState>(
      'should emit [LocaleState] when set locale',
      build: () => LocaleCubit(locale: const Locale('es')),
      act: (cubit) => cubit.setLocale(const Locale('en')),
      expect: () => const <LocaleState>[LocaleState(locale: Locale('en'))],
    );
  });
}
