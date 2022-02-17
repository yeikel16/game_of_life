import 'package:flutter_test/flutter_test.dart';
import 'package:game_of_life/game/cubit/game_cubit.dart';

void main() {
  group('GameState', () {
    test('should return `true` when all board have cero', () {
      const state = GameState(
        board: [
          [0, 0, 0],
          [0, 0, 0],
          [0, 0, 0],
        ],
      );

      expect(state.isAllCero(), isTrue);
    });

    test('should return `false` when all board have cero', () {
      const state = GameState(
        board: [
          [0, 0, 0],
          [0, 1, 0],
          [0, 0, 0],
        ],
      );

      expect(state.isAllCero(), isFalse);
    });

    // should retorn total alive cells
    test('should return total alive cells', () {
      const state = GameState(
        board: [
          [1, 0, 0],
          [0, 1, 0],
          [0, 0, 1],
        ],
      );

      expect(state.totalAliveCells, 3);
    });
  });
}
