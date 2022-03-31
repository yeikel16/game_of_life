import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_of_life/app/app.dart';
import 'package:game_of_life/game/game.dart';
import 'package:game_of_life/l10n/l10n.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const InfoPageView();
  }
}

class InfoPageView extends StatelessWidget {
  const InfoPageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEn = context.select((LocaleCubit element) => element.state.isEn);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.informationTooltip),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text.rich(
            TextSpan(
              text: isEn ? 'The ' : 'El ',
              style: const TextStyle(fontSize: 16),
              children: <TextSpan>[
                TextSpan(
                  text: l10n.gameAppBarTitle,
                  style: const TextStyle(fontSize: 16),
                ),
                TextSpan(
                  text: l10n.gameDescription,
                  style: const TextStyle(fontSize: 16),
                ),
                TextSpan(text: '\n- ${l10n.gameRule1}'),
                TextSpan(text: '\n- ${l10n.gameRule2}'),
                TextSpan(text: '\n- ${l10n.gameRule3}'),
              ],
            ),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const CellWidget(isDead: true),
              const SizedBox(width: 16),
              Text(l10n.labelDead)
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const CellWidget(isDead: false),
              const SizedBox(width: 16),
              Text(l10n.labelLive)
            ],
          ),
          const SizedBox(height: 16),
          GameBoardWidget(
            board: const <List<int>>[
              [0, 0, 0, 0, 0],
              [0, 1, 1, 0, 0],
              [0, 0, 1, 1, 0],
              [0, 0, 0, 0, 0]
            ],
            onCellTap: (int row, int colum) {},
          )
        ],
      ),
    );
  }
}
