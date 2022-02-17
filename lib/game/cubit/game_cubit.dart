import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_state.dart';

typedef Matrix = List<List<int>>;

class GameCubit extends Cubit<GameState> {
  GameCubit({required this.nX, required this.nY})
      : super(GameState.initial(nX: nX, nY: nY));

  final int nX;
  final int nY;

  Future<void> start() async {
    emit(state.copyWith(isGameStart: true));

    while (state.isGameStart) {
      final _newBoard = Matrix.of(state.board);

      await Future<void>.delayed(const Duration(milliseconds: 500));

      for (var x = 0; x < nX; x++) {
        for (var y = 0; y < nY; y++) {
          final nLive = state.board[(x - 1) % nX][(y - 1) % nY] +
              state.board[x % nX][(y - 1) % nY] +
              state.board[(x + 1) % nX][(y - 1) % nY] +
              state.board[(x - 1) % nX][y % nY] +
              state.board[(x + 1) % nX][y % nY] +
              state.board[(x - 1) % nX][(y + 1) % nY] +
              state.board[x % nX][(y + 1) % nY] +
              state.board[(x + 1) % nX][(y + 1) % nY];

          if (state.board[x][y] == 0 && nLive == 3) {
            _newBoard[x] = _setValue(_newBoard[x], y, 1);
          } else if (state.board[x][y] == 1 && (nLive < 2 || nLive > 3)) {
            _newBoard[x] = _setValue(_newBoard[x], y, 0);
          }

          emit(state.copyWith(board: _newBoard));
        }
      }
      if (state.isAllCero()) {
        emit(state.copyWith(isGameStart: false));
      }
    }
  }

  FutureOr<void> activeDeactiveCell({required int row, required int column}) {
    final _board = Matrix.of(state.board);

    if (_board[row][column] == 0) {
      _board[row] = _setValue(_board[row], column, 1);
    } else {
      _board[row] = _setValue(_board[row], column, 0);
    }

    emit(state.copyWith(board: _board));
  }

  List<int> _setValue(List<int> list, int index, int value) {
    final _list = List.of(list);
    _list[index] = value;
    return _list;
  }

  void pause() => emit(state.copyWith(isGameStart: false));

  void reset() => emit(GameState.initial(nX: nX, nY: nY));
}
