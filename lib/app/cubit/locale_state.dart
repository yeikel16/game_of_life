part of 'locale_cubit.dart';

class LocaleState extends Equatable {
  const LocaleState({this.locale});

  final Locale? locale;

  bool get isEn => locale?.languageCode == 'us';

  @override
  List<Object?> get props => [locale];
}
