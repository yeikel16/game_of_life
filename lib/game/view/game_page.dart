import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_of_life/game/cubit/game_cubit.dart';

const cellSize = 25.0;

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final rowCount = (size.width / cellSize).floor().abs();
    final columnCount =
        ((size.height - (kToolbarHeight + 100)) / cellSize).floor().abs();
    return BlocProvider(
      create: (context) => GameCubit(nX: columnCount, nY: rowCount),
      child: const GamePageView(),
    );
  }
}

class GamePageView extends StatelessWidget {
  const GamePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO(yeikel16): add multilanguage support (ES-EN).
        title: const Text('Game of Life'),
        centerTitle: true,
      ),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          return InteractiveViewer(
            constrained: false,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  for (var row = 0; row < state.board.length; row++)
                    Row(
                      children: [
                        for (var colum = 0;
                            colum < state.board[row].length;
                            colum++)
                          Padding(
                            padding: const EdgeInsets.all(1),
                            child: InkWell(
                              key: Key('cell-$row-$colum'),
                              onTap: () =>
                                  context.read<GameCubit>().activeDeactiveCell(
                                        row: row,
                                        column: colum,
                                      ),
                              child: Container(
                                width: cellSize,
                                height: cellSize,
                                decoration: BoxDecoration(
                                  color: state.board[row][colum] == 0
                                      ? Colors.white
                                      : Colors.black,
                                  border: Border.all(width: 0.5),
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Material(
        child: Container(
          height: 50,
          color: Colors.yellow,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlocSelector<GameCubit, GameState, bool>(
                selector: (state) {
                  return state.isGameStart;
                },
                builder: (context, isGameStart) {
                  if (isGameStart) {
                    return IconButton(
                      onPressed: () => context.read<GameCubit>().pause(),
                      icon: const Icon(Icons.pause_rounded),
                    );
                  }
                  return IconButton(
                    onPressed: () => context.read<GameCubit>().start(),
                    icon: const Icon(Icons.play_arrow_rounded),
                  );
                },
              ),
              IconButton(
                onPressed: () => context.read<GameCubit>().reset(),
                icon: const Icon(Icons.settings_backup_restore_rounded),
              ),
              IconButton(
                onPressed: () {
                  context.read<GameCubit>().undo();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('One step back'),
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                },
                icon: const Icon(Icons.undo_outlined),
              ),
              IconButton(
                onPressed: () {
                  if (context.read<GameCubit>().canRedo) {
                    context.read<GameCubit>().redo();
                  } else {
                    context.read<GameCubit>().stepForward();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('One step forward'),
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                },
                icon: const Icon(Icons.redo_rounded),
              ),
              IconButton(
                onPressed: () {
                  // TODO(yeikel16): implement information page abut the game.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Information is not implemented yet'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline_rounded),
              ),
              IconButton(
                onPressed: () {
                  // TODO(yeikel16): implement setting page abut the game.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Setting is not implemented yet'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.settings_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
