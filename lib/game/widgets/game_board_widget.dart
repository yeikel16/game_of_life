import 'package:flutter/material.dart';
import 'package:game_of_life/game/widgets/cell_widget.dart';

class GameBoardWidget extends StatelessWidget {
  const GameBoardWidget({
    Key? key,
    required this.onCellTap,
    required this.board,
  }) : super(key: key);

  final List<List<int>> board;
  final void Function(int row, int colum) onCellTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row = 0; row < board.length; row++)
          Row(
            children: [
              for (var colum = 0; colum < board[row].length; colum++)
                Padding(
                  padding: const EdgeInsets.all(1),
                  child: InkWell(
                    key: Key('cell-$row-$colum'),
                    onTap: () => onCellTap.call(row, colum),
                    child: CellWidget(
                      isDead: board[row][colum] == 0,
                    ),
                  ),
                ),
            ],
          )
      ],
    );
  }
}
