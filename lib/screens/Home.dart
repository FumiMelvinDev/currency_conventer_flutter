import 'package:currency_conventer/components/convert.dart';
import 'package:currency_conventer/data/my_data.dart';
import 'package:currency_conventer/models/latestRateModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<LatestRates> currentRates;
  late Future<Map> currenciesList;
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      currentRates = getRates();
      currenciesList = getCurrencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: FutureBuilder<LatestRates>(
            future: currentRates,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Please check your Internet Connection'),
                );
              }

              if (snapshot.data == null) {
                return const Center(child: Text('Could Make Api Call'));
              }
              return Center(
                child: FutureBuilder<Map>(
                  future: currenciesList,
                  builder: (context, currSnapshot) {
                    if (currSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (currSnapshot.hasError) {
                      return const Center(
                        child: Text('Please check your Internet Connection'),
                      );
                    }

                    if (currSnapshot.data == null) {
                      return const Center(child: Text('Could Make Api Call'));
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Convert(
                          currencies: currSnapshot.data!,
                          rates: snapshot.data!.rates,
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
