import 'package:flutter/material.dart';

const cellSize = 25.0;

class CellWidget extends StatelessWidget {
  const CellWidget({
    Key? key,
    required this.isDead,
  }) : super(key: key);

  final bool isDead;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellSize,
      height: cellSize,
      decoration: BoxDecoration(
        color: isDead ? Colors.white : Colors.black,
        border: Border.all(width: 0.5),
      ),
    );
  }
}
