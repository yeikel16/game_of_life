import 'package:bloc_test/bloc_test.dart';
import 'package:game_of_life/game/cubit/game_cubit.dart';

class MockGameCubit extends MockCubit<GameState> implements GameCubit {}
