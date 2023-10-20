import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map rates;

  DetailPage({required this.rates});

  @override
  Widget build(BuildContext context) {
    double _deviceHeight = MediaQuery.of(context).size.height;
    double _deviceWidth = MediaQuery.of(context).size.width;

    List _currencies = rates.keys.toList();
    List _exchangeRates = rates.values.toList();

    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: _currencies.length,
          itemBuilder: (context, index) {
            String _currency = _currencies[index].toString().toUpperCase();
            String _exchangeRate =
                _exchangeRates[index].toString().toUpperCase();
            return ListTile(
              title: Text(
                "$_currency : $_exchangeRate",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
