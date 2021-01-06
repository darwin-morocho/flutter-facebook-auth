abstract class FacebookAuthWebInterface {
  Future<Map<String, dynamic>> login(List<String> permissions);
  Future<Map<String, dynamic>> isLogged();
  Future<Map<String, dynamic>> getUserData(String fields);
  Future<void> logOut();
}
