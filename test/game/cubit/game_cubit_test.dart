import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_of_life/game/cubit/game_cubit.dart';

void main() {
  group('GameCubit', () {
    blocTest<GameCubit, GameState>(
      'active cells',
      build: () => GameCubit(nX: 2, nY: 2),
      act: (cubit) => cubit
        ..activeDeactiveCell(row: 0, column: 0)
        ..activeDeactiveCell(row: 1, column: 0),
      expect: () => <GameState>[
        const GameState(
          board: [
            [1, 0],
            [0, 0]
          ],
        ),
        const GameState(
          board: [
            [1, 0],
            [1, 0]
          ],
        ),
      ],
    );

    blocTest<GameCubit, GameState>(
      'deactive cells',
      build: () => GameCubit(nX: 2, nY: 2),
      seed: () => const GameState(
        board: [
          [1, 0],
          [1, 0]
        ],
      ),
      act: (cubit) => cubit
        ..activeDeactiveCell(row: 0, column: 0)
        ..activeDeactiveCell(row: 1, column: 0),
      expect: () => <GameState>[
        const GameState(
          board: [
            [0, 0],
            [1, 0]
          ],
        ),
        const GameState(
          board: [
            [0, 0],
            [0, 0]
          ],
        ),
      ],
    );

    group('start', () {
      blocTest<GameCubit, GameState>(
        'with empty board',
        build: () => GameCubit(nX: 3, nY: 3),
        seed: () => const GameState(
          board: [
            [0, 0, 0],
            [0, 1, 0],
            [0, 0, 0],
          ],
        ),
        act: (cubit) => cubit.start(),
        expect: () => const <GameState>[
          GameState(
            board: [
              [0, 0, 0],
              [0, 1, 0],
              [0, 0, 0]
            ],
            isGameStart: true,
          ),
          GameState(
            board: [
              [0, 0, 0],
              [0, 0, 0],
              [0, 0, 0]
            ],
            isGameStart: true,
          ),
          GameState(
            board: [
              [0, 0, 0],
              [0, 0, 0],
              [0, 0, 0]
            ],
          )
        ],
      );
      blocTest<GameCubit, GameState>(
        'should revive cells',
        build: () => GameCubit(nX: 4, nY: 4),
        seed: () => const GameState(
          board: [
            [0, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 1, 1, 0],
            [1, 0, 0, 0],
          ],
        ),
        act: (cubit) => cubit.start(),
        expect: () => const <GameState>[
          GameState(
            board: [
              [0, 0, 0, 0],
              [0, 1, 0, 0],
              [0, 1, 1, 0],
              [1, 0, 0, 0]
            ],
            isGameStart: true,
          ),
          GameState(
            board: [
              [0, 0, 0, 0],
              [0, 1, 1, 0],
              [1, 1, 1, 0],
              [0, 1, 0, 0]
            ],
            isGameStart: true,
          ),
          GameState(
            board: [
              [0, 1, 1, 0],
              [1, 0, 1, 1],
              [1, 0, 0, 1],
              [1, 1, 1, 0]
            ],
            isGameStart: true,
          ),
          GameState(
            board: [
              [0, 0, 0, 0],
              [0, 0, 0, 0],
              [0, 0, 0, 0],
              [0, 0, 0, 0]
            ],
            isGameStart: true,
          ),
          GameState(
            board: [
              [0, 0, 0, 0],
              [0, 0, 0, 0],
              [0, 0, 0, 0],
              [0, 0, 0, 0]
            ],
          )
        ],
      );
    });

    group('pause', () {
      blocTest<GameCubit, GameState>(
        'should emit the `isGameStart` to false',
        build: () => GameCubit(nX: 3, nY: 3),
        seed: () => const GameState(
          board: [
            [0, 0, 0],
            [0, 1, 0],
            [0, 0, 0],
          ],
          isGameStart: true,
        ),
        act: (cubit) => cubit.pause(),
        expect: () => const <GameState>[
          GameState(
            board: [
              [0, 0, 0],
              [0, 1, 0],
              [0, 0, 0]
            ],
          ),
        ],
      );
    });

    group('stepForward', () {
      blocTest<GameCubit, GameState>(
        'should emit the next state',
        build: () => GameCubit(nX: 3, nY: 3),
        seed: () => const GameState(
          board: [
            [0, 0, 0],
            [0, 1, 0],
            [0, 0, 0],
          ],
          isGameStart: true,
        ),
        act: (cubit) => cubit.stepForward(),
        expect: () => const <GameState>[
          GameState(
            board: [
              [0, 0, 0],
              [0, 0, 0],
              [0, 0, 0]
            ],
            isGameStart: true,
          ),
          GameState(
            board: [
              [0, 0, 0],
              [0, 0, 0],
              [0, 0, 0]
            ],
          ),
        ],
      );
    });

    group('reset', () {
      blocTest<GameCubit, GameState>(
        'should emit the `isGameStart` to false',
        build: () => GameCubit(nX: 3, nY: 3),
        seed: () => const GameState(
          board: [
            [0, 0, 0],
            [0, 1, 1],
            [1, 0, 0],
          ],
          isGameStart: true,
        ),
        act: (cubit) => cubit.reset(),
        expect: () => const <GameState>[
          GameState(
            board: [
              [0, 0, 0],
              [0, 0, 0],
              [0, 0, 0]
            ],
          ),
        ],
      );
    });
  });
}
