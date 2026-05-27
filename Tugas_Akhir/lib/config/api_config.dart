import 'package:flutter/foundation.dart';

class ApiConfig {

ApiConfig._();

static String get baseUrl {

if (kIsWeb) {
      return 'http://localhost/learning_api';
    }

return 'http://172.16.30.9/learning_api';
  }
}
