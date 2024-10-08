class PaylinkProduct {
  String title;
  double price;
  int qty;
  String? description;
  bool isDigital;
  String? imageSrc;
  double? specificVat;
  double? productCost;

  PaylinkProduct({
    required this.title,
    required this.price,
    required this.qty,
    this.description,
    this.isDigital = false,
    this.imageSrc,
    this.specificVat,
    this.productCost,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'qty': qty,
      'description': description,
      'isDigital': isDigital,
      'imageSrc': imageSrc,
      'specificVat': specificVat,
      'productCost': productCost,
    };
  }

  factory PaylinkProduct.fromMap(Map<String, dynamic> map) {
    return PaylinkProduct(
      title: map['title'] ?? '',
      price: map['price'] ?? 0.0,
      qty: map['qty'] ?? 0,
      description: map['description'],
      isDigital: map['isDigital'] ?? false,
      imageSrc: map['imageSrc'],
      specificVat: map['specificVat'],
      productCost: map['productCost'],
    );
  }
}
