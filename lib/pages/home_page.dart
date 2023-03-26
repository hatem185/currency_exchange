import 'package:currency_exchange/services/constants.dart';
import 'package:currency_exchange/services/currency_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/common.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<CurrencyProvider>().getLatestRates();
    super.initState();
  }

  var selectedCurrency = "LYD";

  @override
  Widget build(BuildContext context) {
    final provWatcher = context.watch<CurrencyProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Exchange'),
        toolbarHeight: 70,
        actions: const [ConvertCurrencyNav()],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: currencyMenuWidget(context),
              ),
              const SizedBox(height: 10),
              const Text(
                'Latest rates',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const LatestCurrenceyRateStream(),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButton<String> currencyMenuWidget(BuildContext context) {
    final provWatcher = context.watch<CurrencyProvider>();
    final provReader = context.read<CurrencyProvider>();
    return DropdownButton(
      value: provWatcher.baseLatestRate,
      onChanged: (value) {
        if (value == null) return;
        provReader.baseLatestRate = value;
        provReader.getLatestRates();
      },
      items: Constants.getCountryCodesList
          .map(
            (e) => currencyCodeItem(e),
          )
          .toList(),
    );
  }
}

class ConvertCurrencyNav extends StatelessWidget {
  const ConvertCurrencyNav({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Theme.of(context).scaffoldBackgroundColor,
          ),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                50,
              ), // Adjust border radius as needed
            ),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/convert");
        },
        child: Icon(
          Icons.currency_exchange,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class LatestCurrenceyRateStream extends StatelessWidget {
  const LatestCurrenceyRateStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provWatcher = context.watch<CurrencyProvider>();
    final provReader = context.read<CurrencyProvider>();
    return StreamBuilder(
      stream: provWatcher.latestRateStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:const Text("Fiald connection"),
              action: SnackBarAction(
                label: 'Reload',
                onPressed: () {
                  provReader.getLatestRates();
                },
              ),
            ),
          );
          return const Text("Fiald connection");
        } else if (snapshot.hasData) {
          // provReader.latestRateData = snapshot.data;
          return Expanded(
            child: ListView.builder(
                itemCount: snapshot.data?.response?.rates?.length,
                itemBuilder: (context, i) {
                  return Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getImageCode(snapshot
                                  .data?.response?.rates?[i]?.currencyCode
                                  .toString() ??
                              ""),
                          Text(
                            "1 ${snapshot.data?.response?.rates?[i]?.currencyCode.toString()}",
                            style: const TextStyle(fontSize: 21),
                          ),
                          getImageCode(
                              snapshot.data?.response?.base.toString() ?? ""),
                          Text(
                            "${(1.0 / (snapshot.data?.response?.rates?[i]?.rate)!).toStringAsFixed(2)} ${(snapshot.data?.response?.base).toString()}",
                            style: const TextStyle(fontSize: 21),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        } else {
          return const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
