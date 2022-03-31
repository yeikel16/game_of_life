// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_of_life/app/app.dart';
import 'package:game_of_life/game/game.dart';
import 'package:game_of_life/info/info.dart';
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

  group('InfoPage', () {
    testWidgets('renders InfoPageView', (tester) async {
      await tester.pumpApp(
        InfoPage(),
        localeCubit: localeCubit,
      );
      expect(find.byType(InfoPageView), findsOneWidget);
    });
  });

  group('InfoPageView', () {
    testWidgets('renders `Text` and `GameBoard`', (tester) async {
      await tester.pumpApp(
        InfoPageView(),
        localeCubit: localeCubit,
      );
      expect(find.byType(Text), findsNWidgets(4));
      expect(find.byType(GameBoardWidget), findsOneWidget);

      await tester.tap(find.byKey(const Key('cell-1-1')));
    });
  });
}
