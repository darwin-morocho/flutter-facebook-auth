// import 'package:dio/dio.dart';

abstract class MockData {
  static const accessToken = {
    "userId": "136742241592917",
    "token":
        "EAAS5elFDcaYBAB4KyXaxBtEBjkgYpAEZAZAFuV6VHxxfC29l6ZCjgEmYKVguY3Uos5fQ0blVON2WccIvLCQ72EFHDa0ZAmludHCbGN3jNDpzq2L78X74dYTYBAokZAzFWZBwg2biPlEboXkZCWjNWubmE3TES5er3yxZArstszCbQtfue1ECxkjzHhwUkdYNuMJgzo1WVUa4Cc7z2M029srT",
    "expires": 1610201170749,
    "lastRefresh": 1610051315980,
    "applicationId": "1329834907365798",
    "graphDomain": "facebook",
    "isExpired": false,
    "grantedPermissions": ["email", "user_link"],
    "declinedPermissions": [],
  };

  static Future<Map<String, dynamic>> getUserData(String fields) async {
    return {
      "name": "Open Graph Test User",
      "email": "open_jygexjs_user@tfbnw.net",
      "picture": {
        "data": {
          "height": 126,
          "is_silhouette": true,
          "url":
              "https://scontent.fuio21-1.fna.fbcdn.net/v/t1.30497-1/s200x200/84628273_176159830277856_972693363922829312_n.jpg?_nc_cat=1&ccb=2&_nc_sid=12b3be&_nc_ohc=3o6I0i4GDoIAX9NnWZh&_nc_ht=scontent.fuio21-1.fna&tp=7&oh=f4663dde69650ea86114d0839ee8748b&oe=601BA865",
          "width": 200
        }
      },
      "id": "136742241592917"
    };
    // try {
    //   final dio = Dio();
    //   final response = await dio.get(
    //     "https://graph.facebook.com/me",
    //     queryParameters: {
    //       "fields": fields,
    //       "access_token":
    //           "EAAS5elFDcaYBAB4KyXaxBtEBjkgYpAEZAZAFuV6VHxxfC29l6ZCjgEmYKVguY3Uos5fQ0blVON2WccIvLCQ72EFHDa0ZAmludHCbGN3jNDpzq2L78X74dYTYBAokZAzFWZBwg2biPlEboXkZCWjNWubmE3TES5er3yxZArstszCbQtfue1ECxkjzHhwUkdYNuMJgzo1WVUa4Cc7z2M029srT",
    //     },
    //   );
    //   return response.data;
    // } on DioError catch (e) {
    //   print(e.error);
    //   print(e.request.baseUrl);
    //   print(e.request.path);
    //   print(e.request.queryParameters);
    //   print(e.response);
    // }
    // return null;
  }
}
