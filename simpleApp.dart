import 'dart:io';

// Entity
class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';
}

// Repository
abstract class ProductRepository {
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
  Future<List<Product>> getProducts();
}

//  Implementation
class InMemoryProductRepository implements ProductRepository {
  final List<Product> _products = [];

  @override
  Future<void> addProduct(Product product) async {
    _products.add(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
  }

  @override
  Future<List<Product>> getProducts() async {
    return _products;
  }
}

//  Use Cases
class ProductUseCases {
  final ProductRepository repository;

  ProductUseCases(this.repository);

  Future<void> addProduct(Product product) async {
    await repository.addProduct(product);
  }

  Future<void> updateProduct(Product product) async {
    await repository.updateProduct(product);
  }

  Future<void> deleteProduct(String id) async {
    await repository.deleteProduct(id);
  }

  Future<List<Product>> getProducts() async {
    return await repository.getProducts();
  }
}

// Console UI
class ConsoleUI {
  final ProductUseCases useCases;

  ConsoleUI(this.useCases);

  Future<void> start() async {
    while (true) {
      print('\n--- Product Manager ---');
      print('1. Add Product');
      print('2. Update Product');
      print('3. Delete Product');
      print('4. View Products');
      print('5. Exit');
      stdout.write('Choose an option: ');
      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          await _addProduct();
          break;
        case '2':
          await _updateProduct();
          break;
        case '3':
          await _deleteProduct();
          break;
        case '4':
          await _viewProducts();
          break;
        case '5':
          print('Exiting...');
          return;
        default:
          print('Invalid choice. Try again.');
      }
    }
  }

  Future<void> _addProduct() async {
    stdout.write('Enter product ID: ');
    final id = stdin.readLineSync();
    stdout.write('Enter product name: ');
    final name = stdin.readLineSync();
    stdout.write('Enter product price: ');
    final price = double.parse(stdin.readLineSync()!);

    final product = Product(id: id!, name: name!, price: price);
    await useCases.addProduct(product);
    print('Product added successfully.');
  }

  Future<void> _updateProduct() async {
    stdout.write('Enter product ID to update: ');
    final id = stdin.readLineSync();
    stdout.write('Enter new product name: ');
    final name = stdin.readLineSync();
    stdout.write('Enter new product price: ');
    final price = double.parse(stdin.readLineSync()!);

    final product = Product(id: id!, name: name!, price: price);
    await useCases.updateProduct(product);
    print('Product updated successfully.');
  }

  Future<void> _deleteProduct() async {
    stdout.write('Enter product ID to delete: ');
    final id = stdin.readLineSync();
    await useCases.deleteProduct(id!);
    print('Product deleted successfully.');
  }

  Future<void> _viewProducts() async {
    final products = await useCases.getProducts();
    if (products.isEmpty) {
      print('No products found.');
    } else {
      print('\n--- Products ---');
      for (final product in products) {
        print(product);
      }
    }
  }
}

// Main Function
void main() {
  final repository = InMemoryProductRepository();
  final useCases = ProductUseCases(repository);
  final consoleUI = ConsoleUI(useCases);

  consoleUI.start();
}
