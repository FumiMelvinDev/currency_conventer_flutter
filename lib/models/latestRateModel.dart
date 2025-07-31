// To parse this JSON data, do
//
//     final latestRates = latestRatesFromJson(jsonString);

import 'dart:convert';

LatestRates latestRatesFromJson(String str) =>
    LatestRates.fromJson(json.decode(str));

String latestRatesToJson(LatestRates data) => json.encode(data.toJson());

class LatestRates {
  String disclaimer;
  String license;
  int timestamp;
  String base;
  Map<String, double> rates;

  LatestRates({
    required this.disclaimer,
    required this.license,
    required this.timestamp,
    required this.base,
    required this.rates,
  });

  factory LatestRates.fromJson(Map<String, dynamic> json) => LatestRates(
        disclaimer: json["disclaimer"],
        license: json["license"],
        timestamp: json["timestamp"],
        base: json["base"],
        rates: Map.from(json["rates"])
            .map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "disclaimer": disclaimer,
        "license": license,
        "timestamp": timestamp,
        "base": base,
        "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
