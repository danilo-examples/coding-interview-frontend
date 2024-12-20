import 'package:http/http.dart' as http;

class ApiService {

  static String urlConversion = "https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage/orderbook/public/recommendations";

  static Future<http.Response> getConversion({Map<String, dynamic>? queryParams}) async {
    http.Response response = await http.get(
      Uri.parse(urlConversion).replace(queryParameters: queryParams,),
      headers: {'Content-Type': 'application/json',},
    );

    if(response.statusCode != 200){
      throw "Error en la api $urlConversion";
    }

    return response;
  }
}