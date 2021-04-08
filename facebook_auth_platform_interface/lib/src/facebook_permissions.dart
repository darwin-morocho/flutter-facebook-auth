import 'package:meta/meta.dart' show required;

class FacebookPermissions {
  final List<String> granted, declined;
  FacebookPermissions({
    @required this.granted,
    @required this.declined,
  });
}
