part of 'locale_cubit.dart';

class LocaleState extends Equatable {
  const LocaleState({this.locale});

  final Locale? locale;

  @override
  List<Object?> get props => [locale];
}
