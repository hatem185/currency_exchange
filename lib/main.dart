import 'package:currency_exchange/pages/currency_converter_page.dart';
import 'package:currency_exchange/pages/home_page.dart';
import 'package:currency_exchange/services/constants.dart';
import 'package:currency_exchange/services/currency_services.dart';
import 'package:currency_exchange/themes/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main()async  {
  await dotenv.load();
  Constants.apiKey = dotenv.env['API_KEY']!;
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CurrencyProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: priamarySwatchColor, primaryColor: primaryColor),
      // home: const HomePage(title: 'Flutter Demo Home Page'),
      initialRoute: "/home",
      routes: {
        "/home": (context) => const HomePage(),
        "/convert": (context) => const CurrencyConverterPage(),
      },
    );
  }
}
