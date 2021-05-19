/// this class is used to saved the granted and declined permissions after login
class FacebookPermissions {
  /// save the granted permissions by the user
  final List<String> granted;

  /// save the declined permissions by the user
  final List<String> declined;

  FacebookPermissions({required this.granted, required this.declined});
}
