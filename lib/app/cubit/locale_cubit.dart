import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit({required Locale locale}) : super(LocaleState(locale: locale));

  void setLocale(Locale? locale) {
    emit(LocaleState(locale: locale));
  }
}
