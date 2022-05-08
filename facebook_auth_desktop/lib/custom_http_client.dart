import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CustomHttpClient {
  Future<Response> get(Uri url) async {
    return http.get(url);
  }
}
