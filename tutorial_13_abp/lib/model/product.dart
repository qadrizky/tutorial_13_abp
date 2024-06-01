class Product {
  final String id; // Use String for UUIDs
  final String name;
  final int quantity; // Use int for 'jumlah'
  final double price;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['nama'] as String,
      quantity: json['jumlah'] as int,
      price: json['harga'].toDouble() as double, // Assuming 'harga' is a double
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'jumlah': quantity,
        'harga': price,
        'image': image,
      };

  @override
  String toString() {
    return 'Product(id: $id, name: $name, quantity: $quantity, price: $price, image: $image)';
  }
}
