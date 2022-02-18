import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_of_life/game/game.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  late GameCubit gameCubit;

  setUp(() {
    gameCubit = MockGameCubit();
    when(() => gameCubit.state).thenAnswer(
      (invocation) => const GameState(
        board: [
          [0, 0, 0],
          [0, 0, 0],
          [0, 0, 0],
        ],
      ),
    );
  });
  group('GamePage', () {
    testWidgets('renders GamePageView', (tester) async {
      await tester.pumpApp(const GamePage(), bloc: gameCubit);
      expect(find.byType(GamePageView), findsOneWidget);
    });
  });

  group('GamePageView', () {
    testWidgets('renders game board', (tester) async {
      await tester.pumpApp(
        BlocProvider(
          create: (context) => gameCubit,
          child: const GamePageView(),
        ),
        bloc: gameCubit,
      );
      expect(find.byType(InteractiveViewer), findsOneWidget);
    });

    testWidgets('actived a cell', (tester) async {
      await tester.pumpApp(
        BlocProvider(
          create: (context) => gameCubit,
          child: const GamePageView(),
        ),
        bloc: gameCubit,
      );

      await tester.tap(find.byKey(const Key('cell-1-1')));

      verify(() => gameCubit.activeDeactiveCell(row: 1, column: 1)).called(1);
    });

    group('tap in', () {
      testWidgets(
        'information button',
        (WidgetTester tester) async {
          await tester.pumpApp(
            BlocProvider(
              create: (context) => gameCubit,
              child: const GamePageView(),
            ),
            bloc: gameCubit,
          );
          await tester.tap(find.byIcon(Icons.info_outline_rounded));
          await tester.pumpAndSettle();

          expect(find.byType(SnackBar), findsOneWidget);
        },
      );
      testWidgets(
        'setting button',
        (WidgetTester tester) async {
          await tester.pumpApp(
            BlocProvider(
              create: (context) => gameCubit,
              child: const GamePageView(),
            ),
            bloc: gameCubit,
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
            BlocProvider(
              create: (context) => gameCubit,
              child: const GamePageView(),
            ),
            bloc: gameCubit,
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
            BlocProvider(
              create: (context) => gameCubit,
              child: const GamePageView(),
            ),
            bloc: gameCubit,
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
            BlocProvider(
              create: (context) => gameCubit,
              child: const GamePageView(),
            ),
            bloc: gameCubit,
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
            BlocProvider(
              create: (context) => gameCubit,
              child: const GamePageView(),
            ),
            bloc: gameCubit,
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
            BlocProvider(
              create: (context) => gameCubit,
              child: const GamePageView(),
            ),
            bloc: gameCubit,
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
            BlocProvider(
              create: (context) => gameCubit,
              child: const GamePageView(),
            ),
            bloc: gameCubit,
          );
          await tester.tap(find.byIcon(Icons.pause_rounded));

          verify(() => gameCubit.pause()).called(1);
        },
      );
    });
  });
}
