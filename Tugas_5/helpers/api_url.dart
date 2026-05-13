import 'package:flutter/foundation.dart';

class ApiUrl {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost/toko-api/public';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Android emulator cannot access host machine via localhost.
      return 'http://10.0.2.2/toko-api/public';
    }
    return 'http://localhost/toko-api/public';
  }

  static String get registrasi => '$baseUrl/registrasi';
  static String get login => '$baseUrl/login';
  static String get listProduk => '$baseUrl/produk';
  static String get createProduk => '$baseUrl/produk';

  static String updateProduk(int id) {
    return '$baseUrl/produk/$id/update';
  }

  static String showProduk(int id) {
    return '$baseUrl/produk/$id';
  }

  static String deleteProduk(int id) {
    return '$baseUrl/produk/$id';
  }
}
