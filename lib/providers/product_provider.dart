import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  // Data dummy dengan gambar asli (URL)
  final List<Product> _items = [
    Product(
      id: '1',
      name: 'Noir Chronograph',
      description: 'Jam tangan mekanik premium dengan dial hitam.',
      price: 12500000,
      category: 'Watches',
      imageUrl:
          'https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=500&auto=format&fit=crop',
    ),
    Product(
      id: '2',
      name: 'Classic Oxford Shirt',
      description: 'Kemeja potongan reguler dari katun premium.',
      price: 399000,
      category: 'Clothing',
      imageUrl:
          'https://images.unsplash.com/photo-1596755094514-f87e32f85e2c?q=80&w=500&auto=format&fit=crop',
    ),
    Product(
      id: '3',
      name: 'Silver Link Bracelet',
      description: 'Gelang rantai perak murni bergaya maskulin.',
      price: 850000,
      category: 'Accessories',
      imageUrl:
          'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?q=80&w=500&auto=format&fit=crop',
    ),
    Product(
      id: '4',
      name: 'Leather Weekend Bag',
      description: 'Tas kulit asli untuk perjalanan singkat.',
      price: 1599000,
      category: 'Bags',
      imageUrl:
          'https://images.unsplash.com/photo-1547949003-9792a18a2601?q=80&w=500&auto=format&fit=crop',
    ),
  ];

  // Getter yang otomatis mengurutkan produk: Like (true) akan berada di atas
  List<Product> get items {
    List<Product> sortedList = [..._items];
    sortedList.sort((a, b) {
      if (a.isFavorite == b.isFavorite) return 0;
      return a.isFavorite ? -1 : 1; // -1 berarti ditaruh di atas
    });
    return sortedList;
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void toggleFavorite(String id) {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      _items[index].isFavorite = !_items[index].isFavorite;
      notifyListeners(); // Update UI
    }
  }
}
