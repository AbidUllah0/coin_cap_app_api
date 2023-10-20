import 'dart:convert';
import 'dart:io';

import 'package:coin_cap_app/Views/Detail_Page/detail_page.dart';
import 'package:coin_cap_app/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  HTTPService? _httpService;
  String? _selectedCoin = 'bitcoin';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _httpService = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _selectedCoinDropDown(),
                _dataFetch(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectedCoinDropDown() {
    List<String> _coinsList = [
      'bitcoin',
      'ethereum',
      'tether',
      'cardano',
      'ripple'
    ];
    List<DropdownMenuItem<String>> _items = _coinsList
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .toList();

    return DropdownButton(
      value: _selectedCoin,
      items: _items,
      onChanged: (dynamic value) {
        setState(() {
          _selectedCoin = value;
        });
      },
      dropdownColor: Color.fromRGBO(83, 88, 206, 1.0),
      iconSize: 30,
      icon: Icon(
        Icons.keyboard_arrow_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  //fetching data
  Widget _dataFetch() {
    return FutureBuilder(
      future: _httpService!.get('/coins/$_selectedCoin'),
      builder: (BuildContext context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          Map _data = jsonDecode(_snapshot.data.toString());

          ///price

          num _usdPrice = _data['market_data']['current_price']['usd'];
          num _change24h = _data['market_data']['price_change_percentage_24h'];
          String _coinImg = _data["image"]["large"];
          String _description = _data["description"]["en"];
          Map _exchangeRates = _data["market_data"]["current_price"];
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          rates: _exchangeRates,
                        ),
                      ),
                    );
                  },
                  child: _displayCoinImage(_coinImg)),
              _currentPriceWidget(_usdPrice),
              _percentageChangeWidget(_change24h),
              _descriptioniCard(_description)
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
      },
    );
  }

//current price
  Widget _currentPriceWidget(num _rate) {
    return Text(
      '${_rate.toStringAsFixed(2)} USD',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 15,
      ),
    );
  }

  //percentage change
  Widget _percentageChangeWidget(num _change) {
    return Text(
      _change.toString(),
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  ///Displaying coin image
  Widget _displayCoinImage(String _imageUrl) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.02),
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            _imageUrl,
          ),
        ),
      ),
    );
  }

  Widget _descriptioniCard(String _description) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.05),
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.01,
        horizontal: 0.01,
      ),
      height: _deviceHeight! * 0.45,
      width: _deviceWidth! * 0.90,
      color: Color.fromRGBO(83, 88, 206, 0.5),
      child: Text(
        _description,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
