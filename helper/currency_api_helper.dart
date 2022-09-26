import 'dart:convert';
import 'package:currency_convertor_app/home_page.dart';
import 'package:http/http.dart' as http;

import '../modals/currency.dart';

class CurrencyAPIHelper {
  CurrencyAPIHelper._();

  static final CurrencyAPIHelper apiHelper = CurrencyAPIHelper._();

  String baseUrl =
      'https://openexchangerates.org/api/latest.json?base=USD&app_id=';
  String endPoint = '2a3c329995524a3eafca591cf4182c57';

  Future<Currency?> fetchcurrencies() async {
    http.Response res = await http.get(
      Uri.parse(baseUrl + endPoint),
    );
    final decodedData =
    Currency.allCurrenciesFromJson(json: json.decode(res.body));
    return decodedData;
  }
}

String convertansy(Map exchangeRates, String amount, String currencybase,
    String currencyfinal) {
  String output = (double.parse(amount) /
      exchangeRates[currencybase] *
      exchangeRates[currencyfinal])
      .toStringAsFixed(2)
      .toString();

  return output;
}