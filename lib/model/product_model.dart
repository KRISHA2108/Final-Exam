class Product {
  int id;
  String name;
  String category;
  double price;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
  });

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map['id'],
        name: map['name'],
        category: map['category'],
        price: map['price'],
      );

  // SQLite to/from Map
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'price': price,
      };
}
