import 'package:currency_convertor_app/home_page.dart';

class Currency {
  final Map<String, double> allRates;

  Currency({
    required this.allRates,
  });

  factory Currency.allCurrenciesFromJson({required Map<String, dynamic> json}) {
    return Currency(
      allRates: Map.from(json['rates'])
          .map((key, value) => MapEntry<String, double>(key, value.toDouble())),
    );
  }
}