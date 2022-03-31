import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_of_life/app/app.dart';
import 'package:game_of_life/game/game.dart';
import 'package:game_of_life/info/info.dart';
import 'package:game_of_life/l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  late GameCubit gameCubit;
  late LocaleCubit localeCubit;

  setUp(() {
    gameCubit = MockGameCubit();
    localeCubit = MockLocaleCubit();
    when(() => gameCubit.state).thenAnswer(
      (invocation) => const GameState(
        board: [
          [0, 0, 0],
          [0, 0, 0],
          [0, 0, 0],
        ],
      ),
    );
    when(() => localeCubit.state).thenAnswer(
      (_) => const LocaleState(locale: Locale('en', 'US')),
    );
  });
  group('GamePage', () {
    testWidgets('renders GamePageView', (tester) async {
      await tester.pumpApp(
        const GamePage(),
        gameCubit: gameCubit,
        localeCubit: localeCubit,
      );
      expect(find.byType(GamePageView), findsOneWidget);
    });
  });

  group('GamePageView', () {
    testWidgets('renders game board', (tester) async {
      await tester.pumpApp(
        const GamePageView(),
        gameCubit: gameCubit,
        localeCubit: localeCubit,
      );
      expect(find.byType(InteractiveViewer), findsOneWidget);
    });

    group('tap in', () {
      testWidgets(
        'info button should navegate to `InfoPage`.',
        (tester) async {
          await tester.pumpWidget(
            BlocProvider.value(
              value: localeCubit,
              child: const AppView(),
            ),
          );
          final materialApp =
              tester.widget<MaterialApp>(find.byType(MaterialApp));

          expect(materialApp.routes?.length, equals(2));

          await tester.tap(find.byIcon(Icons.info_outline_rounded));
          await tester.pumpAndSettle();

          expect(find.byType(InfoPage), findsOneWidget);
        },
      );

      testWidgets(
        'setting button',
        (WidgetTester tester) async {
          await tester.pumpApp(
            const GamePageView(),
            gameCubit: gameCubit,
            localeCubit: localeCubit,
          );
          await tester.tap(find.byIcon(Icons.settings_rounded));
          await tester.pumpAndSettle();

          expect(find.byType(SnackBar), findsOneWidget);
        },
      );

      testWidgets(
        'redo button when have more state',
        (WidgetTester tester) async {
          when(() => gameCubit.canRedo).thenReturn(true);
          await tester.pumpApp(
            const GamePageView(),
            gameCubit: gameCubit,
            localeCubit: localeCubit,
          );
          await tester.tap(find.byIcon(Icons.redo_rounded));
          await tester.pumpAndSettle();

          expect(find.byType(SnackBar), findsOneWidget);
          verify(() => gameCubit.redo()).called(1);
        },
      );

      testWidgets(
        'redo button when not have more state',
        (WidgetTester tester) async {
          when(() => gameCubit.canRedo).thenReturn(false);
          await tester.pumpApp(
            const GamePageView(),
            gameCubit: gameCubit,
            localeCubit: localeCubit,
          );
          await tester.tap(find.byIcon(Icons.redo_rounded));
          await tester.pumpAndSettle();

          expect(find.byType(SnackBar), findsOneWidget);
          verify(() => gameCubit.stepForward()).called(1);
        },
      );

      testWidgets(
        'undo button',
        (WidgetTester tester) async {
          await tester.pumpApp(
            const GamePageView(),
            gameCubit: gameCubit,
            localeCubit: localeCubit,
          );
          await tester.tap(find.byIcon(Icons.undo_outlined));
          await tester.pumpAndSettle();

          expect(find.byType(SnackBar), findsOneWidget);
          verify(() => gameCubit.undo()).called(1);
        },
      );

      testWidgets(
        'reset button',
        (WidgetTester tester) async {
          await tester.pumpApp(
            const GamePageView(),
            gameCubit: gameCubit,
            localeCubit: localeCubit,
          );
          await tester.tap(find.byIcon(Icons.settings_backup_restore_rounded));

          verify(() => gameCubit.reset()).called(1);
        },
      );

      testWidgets(
        'play button',
        (WidgetTester tester) async {
          when(() => gameCubit.start()).thenAnswer((_) => Future.value());

          await tester.pumpApp(
            const GamePageView(),
            gameCubit: gameCubit,
            localeCubit: localeCubit,
          );
          await tester.tap(find.byIcon(Icons.play_arrow_rounded));

          verify(() => gameCubit.start()).called(1);
        },
      );

      testWidgets(
        'pause button',
        (WidgetTester tester) async {
          when(() => gameCubit.state).thenAnswer(
            (invocation) => const GameState(
              board: [
                [0, 0, 0],
                [0, 0, 0],
                [0, 0, 0],
              ],
              isGameStart: true,
            ),
          );

          await tester.pumpApp(
            const GamePageView(),
            gameCubit: gameCubit,
            localeCubit: localeCubit,
          );
          await tester.tap(find.byIcon(Icons.pause_rounded));

          verify(() => gameCubit.pause()).called(1);
        },
      );
    });
  });

  group('SelectLocaleWidget', () {
    testWidgets(
      'show locales options and change locale option',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          Localizations(
            delegates: AppLocalizations.localizationsDelegates,
            locale: const Locale('en', 'US'),
            child: BlocProvider(
              create: (context) => localeCubit,
              child: const MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                home: Material(child: SelectLocaleWidget()),
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.arrow_drop_down_rounded));
        await tester.pumpAndSettle();

        expect(find.text('EN'), findsOneWidget);
        expect(find.text('ES'), findsOneWidget);

        await tester.tap(find.text('ES'));
        await tester.pumpAndSettle();

        verify(() => localeCubit.setLocale(const Locale('es'))).called(1);
      },
    );
  });
}
