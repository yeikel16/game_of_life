import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_of_life/app/cubit/locale_cubit.dart';
import 'package:game_of_life/game/game.dart';
import 'package:game_of_life/l10n/l10n.dart';

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
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.gameAppBarTitle),
        centerTitle: true,
        actions: [
          Row(
            children: [
              const Icon(Icons.language_rounded),
              const SizedBox(width: 8),
              Text(
                context
                    .select(
                      (LocaleCubit cubit) => cubit.state.locale!.languageCode,
                    )
                    .toUpperCase(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 18),
            child: SelectLocaleWidget(),
          ),
        ],
      ),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          return InteractiveViewer(
            constrained: false,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: GameBoardWidget(
                board: state.board,
                onCellTap: (int row, int colum) =>
                    context.read<GameCubit>().activeDeactiveCell(
                          row: row,
                          column: colum,
                        ),
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
                      tooltip: l10n.pauseTooltip,
                      onPressed: () => context.read<GameCubit>().pause(),
                      icon: const Icon(Icons.pause_rounded),
                    );
                  }
                  return IconButton(
                    tooltip: l10n.playTooltip,
                    onPressed: () => context.read<GameCubit>().start(),
                    icon: const Icon(Icons.play_arrow_rounded),
                  );
                },
              ),
              IconButton(
                tooltip: l10n.resetTooltip,
                onPressed: () => context.read<GameCubit>().reset(),
                icon: const Icon(Icons.settings_backup_restore_rounded),
              ),
              IconButton(
                tooltip: l10n.backwardTooltip,
                onPressed: () {
                  context.read<GameCubit>().undo();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.backwardTooltip),
                      duration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                icon: const Icon(Icons.undo_outlined),
              ),
              IconButton(
                tooltip: l10n.forwardTooltip,
                onPressed: () {
                  if (context.read<GameCubit>().canRedo) {
                    context.read<GameCubit>().redo();
                  } else {
                    context.read<GameCubit>().stepForward();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.forwardTooltip),
                      duration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                icon: const Icon(Icons.redo_rounded),
              ),
              IconButton(
                tooltip: l10n.informationTooltip,
                onPressed: () {
                  // TODO(yeikel16): implement information page abut the game.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.informationNotImplemented),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline_rounded),
              ),
              IconButton(
                tooltip: l10n.settingsTooltip,
                onPressed: () {
                  // TODO(yeikel16): implement setting page abut the game.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.settingsNotImplemented),
                      duration: const Duration(seconds: 1),
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

class SelectLocaleWidget extends StatelessWidget {
  const SelectLocaleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopupMenuButton<Locale>(
      tooltip: l10n.languageTooltip,
      initialValue: context.select((LocaleCubit cubit) => cubit.state.locale),
      icon: const Icon(Icons.arrow_drop_down_rounded),
      onSelected: (Locale? newLocale) =>
          context.read<LocaleCubit>().setLocale(newLocale),
      itemBuilder: (context) {
        return AppLocalizations.supportedLocales
            .map<PopupMenuItem<Locale>>((Locale value) {
          return PopupMenuItem<Locale>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  value.languageCode.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList();
      },
    );
  }
}
