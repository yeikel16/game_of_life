part of 'game_cubit.dart';

class GameState extends Equatable {
  const GameState({required this.board, this.isGameStart = false});

  factory GameState.initial({required int nX, required int nY}) =>
      GameState(board: List.generate(nX, (x) => List.generate(nY, (y) => 0)));

  final Matrix board;
  final bool isGameStart;

  GameState copyWith({
    Matrix? board,
    bool? isGameStart,
  }) {
    return GameState(
      board: board ?? this.board,
      isGameStart: isGameStart ?? this.isGameStart,
    );
  }

  bool isAllCero() => totalAliveCells == 0;

  int get totalAliveCells => board
      .reduce((value, element) => [...value, ...element])
      .reduce((value, element) => value + element);

  @override
  List<Object?> get props => [Matrix.from(board), isGameStart];
}
