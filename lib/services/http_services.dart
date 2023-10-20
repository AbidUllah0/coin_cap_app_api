import 'package:coin_cap_app/models/app_config.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();

  AppConfig? _appConfig;
  String? _baseUrl;

  HTTPService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    _baseUrl = _appConfig!.COIN_API_BASE_URL;
  }

  Future<Response?> get(String _path) async {
    try {
      /// _path coins/bitcoin
      ///_base Url 'https://api.coingecko.com/api/v3/
      ///_baseurl_path https://api.coingecko.com/api/v3/coins/bitcoin
      String url = "$_baseUrl$_path";
      Response _response = await dio.get(url);
      return _response;
    } catch (e) {
      print('HTTP service : Unable to perform get request ');
    }
  }
}
