// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_of_life/app/app.dart';
import 'package:game_of_life/game/game.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  late LocaleCubit localeCubit;

  setUp(() {
    localeCubit = MockLocaleCubit();

    when(() => localeCubit.state).thenAnswer(
      (_) => const LocaleState(locale: Locale('en', 'US')),
    );
  });

  group('App', () {
    testWidgets('renders AppView', (tester) async {
      await tester.pumpApp(App(), localeCubit: localeCubit);
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    testWidgets('renders GamePage', (tester) async {
      await tester.pumpApp(AppView(), localeCubit: localeCubit);
      expect(find.byType(GamePage), findsOneWidget);
    });
  });
}
