import 'package:flutter/material.dart';
import 'package:tutorial_13_abp/api_services.dart';
import 'package:tutorial_13_abp/model/product.dart';

void main() => runApp(MaterialApp(home: ProductListScreen()));

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await ApiService().fetchProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      // Handle errors (e.g., show a SnackBar or dialog)
      print('Error fetching products: $e');
    }
  }

  Future<void> _addProduct() async {
    String name = _nameController.text;
    int? quantity = int.tryParse(_quantityController.text);
    double? price = double.tryParse(_priceController.text);
    String image = _imageController.text;

    if (name.isNotEmpty &&
        quantity != null &&
        price != null &&
        image.isNotEmpty) {
      try {
        final newProduct = Product(
          name: name,
          quantity: quantity,
          price: price,
          image: image,
          id: '',
        );

        final addedProduct = await ApiService().addProduct(newProduct);

        if (addedProduct != null) {
          _nameController.clear();
          _quantityController.clear();
          _priceController.clear();
          _imageController.clear();
          _fetchProducts();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product added successfully!')),
          );
        }
      } catch (e) {
        print('Error adding product: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: _products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  leading: product.image.isNotEmpty
                      ? Image.network(
                          product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : null,
                  title: Text(product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: ${product.quantity}'),
                      Text(
                          '\$${product.price.toStringAsFixed(2)}'), // Format the price
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add Product'),
              content: SingleChildScrollView(
                // Added for scrolling in case of overflow
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(hintText: 'Quantity'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _priceController,
                      decoration: InputDecoration(hintText: 'Price'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                    TextField(
                      controller: _imageController,
                      decoration: InputDecoration(hintText: 'Image URL'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _addProduct();
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
