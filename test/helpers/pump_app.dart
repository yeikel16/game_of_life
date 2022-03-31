// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_of_life/app/app.dart';
import 'package:game_of_life/game/game.dart';
import 'package:game_of_life/l10n/l10n.dart';

import 'helpers.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    GameCubit? gameCubit,
    LocaleCubit? localeCubit,
  }) async {
    return pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: gameCubit ?? MockGameCubit()),
          BlocProvider.value(value: localeCubit ?? MockLocaleCubit()),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}
