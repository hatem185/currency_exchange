import 'package:currency_exchange/services/constants.dart';
import 'package:currency_exchange/services/currency_services.dart';
import 'package:country_icons/country_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/common.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final fromTextController = TextEditingController(text: "");
  final toTextController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provWatch = context.watch<CurrencyProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Converter"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Card(
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Amount",
                        style: TextStyle(fontSize: 21),
                      ),
                      const SizedBox(height: 10),
                      AmountItem(
                        amountController: fromTextController,
                        countryCode: provWatch.fromCode,
                        isFrom: true,
                      ),
                      const SizedBox(height: 20),
                      if (provWatch.isConverLoading)
                        const Align(alignment: Alignment.center,child:  CircularProgressIndicator())
                      else
                        exchangeSpliter(
                          context,
                          onClick: () async {
                            await context
                                .read<CurrencyProvider>()
                                .currencyConverter(
                                  double.parse(fromTextController.text),
                                );
                            toTextController.text =
                                "${provWatch.convertData?.response?.value?.toStringAsFixed(3)}";
                            provWatch.refresh();
                          },
                        ),
                      const SizedBox(height: 20),
                      const Text(
                        "Converted amount",
                        style: TextStyle(fontSize: 21),
                      ),
                      const SizedBox(height: 10),
                      AmountItem(
                        amountController: toTextController,
                        countryCode: provWatch.toCode,
                        isFrom: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row exchangeSpliter(
    BuildContext context, {
    required void Function() onClick,
  }) {
    return Row(
      children: [
        spliterCrossLine(context),
        const SizedBox(width: 10),
        exchangeCurrencyBtn(onClick: onClick),
        const SizedBox(width: 10),
        spliterCrossLine(context),
      ],
    );
  }

  Expanded spliterCrossLine(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  SizedBox exchangeCurrencyBtn({required void Function() onClick}) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                50,
              ), // Adjust border radius as needed
            ),
          ),
        ),
        onPressed: onClick,
        child: const Icon(
          Icons.currency_exchange_sharp,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}

class AmountItem extends StatefulWidget {
  const AmountItem({
    super.key,
    required this.amountController,
    required this.countryCode,
    this.isFrom = false,
  });

  final bool isFrom;
  final TextEditingController amountController;
  final String countryCode;

  @override
  State<AmountItem> createState() => _AmountItemState();
}

class _AmountItemState extends State<AmountItem> {
  String? selectedCode;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    selectedCode = widget.countryCode;
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<CurrencyProvider>();
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: getImageCode(widget.isFrom ? prov.fromCode : prov.toCode),
        ),
        const SizedBox(width: 10),
        DropdownButton(
          value: widget.isFrom ? prov.fromCode : prov.toCode,
          onChanged: (value) {
            if (value == null) return;
            if (widget.isFrom) {
              context.read<CurrencyProvider>().fromCode = value;
              print("from: $selectedCode");
            } else {
              context.read<CurrencyProvider>().toCode = value;
              print("to: $selectedCode");
            }
          },
          items: Constants.getCountryCodesList
              .map(
                (e) => currencyCodeItem(e),
              )
              .toList(),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AmountTextField(
            textController: widget.amountController,
          ),
        ),
      ],
    );
  }
}

class AmountTextField extends StatefulWidget {
  const AmountTextField({super.key, required this.textController});

  final TextEditingController textController;

  @override
  State<AmountTextField> createState() => _AmountTextFieldState();
}

class _AmountTextFieldState extends State<AmountTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }
}
