import 'package:currency_conventer/data/my_data.dart';
import 'package:flutter/material.dart';

class Convert extends StatefulWidget {
  final rates;
  final Map currencies;
  const Convert({super.key, this.rates, required this.currencies});

  @override
  State<Convert> createState() => _ConvertState();
}

class _ConvertState extends State<Convert> {
  TextEditingController amountController = TextEditingController(text: '1.00');
  String currencyFromValue = 'USD';
  String currencyToValue = 'ZAR';
  String answer = '';

  @override
  void initState() {
    super.initState();
    calculateConversion();
  }

  void swapCurrencies() {
    setState(() {
      final temp = currencyFromValue;
      currencyFromValue = currencyToValue;
      currencyToValue = temp;
      calculateConversion();
    });
  }

  void calculateConversion() {
    double amount = double.tryParse(amountController.text) ?? 0.0;
    double fromRate = widget.rates[currencyFromValue] ?? 1.0;
    double toRate = widget.rates[currencyToValue] ?? 1.0;
    double result = 0.0;

    if (fromRate != 0) {
      result = amount / fromRate * toRate;
    }

    setState(() {
      answer = result.toStringAsFixed(2);
    });
  }

  Widget currencyRow({
    required String label,
    required String currency,
    required Widget inputWidget,
    required bool showFlag,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (showFlag)
                // Replace with your flag widget or asset
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(
                    'assets/flags/$currency.png',
                  ), // e.g. assets/flags/USD.png
                ),
              if (showFlag) const SizedBox(width: 8),
              DropdownButton<String>(
                value: currency,
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down),
                items: widget.currencies.keys
                    .toSet()
                    .toList()
                    .map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    })
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    if (label == "Amount") {
                      currencyFromValue = newValue!;
                    } else {
                      currencyToValue = newValue!;
                    }
                  });
                },
              ),
              const SizedBox(width: 12),
              Expanded(child: inputWidget),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text(
            "Currency Converter",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Check live rates, set rate alerts, receive notifications and more.",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.10),
                  spreadRadius: 2,
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                currencyRow(
                  label: "Amount",
                  currency: currencyFromValue,
                  showFlag: true,
                  inputWidget: TextField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "1000.00",
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (val) {
                      calculateConversion();
                    },
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: swapCurrencies,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.15),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.swap_vert,
                      size: 32,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                currencyRow(
                  label: "Converted Amount",
                  currency: currencyToValue,
                  showFlag: true,
                  inputWidget: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      answer,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
