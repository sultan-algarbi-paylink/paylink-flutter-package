import 'package:flutter/material.dart';

class Product {
  final String name;
  final String description;
  final double price;

  Product({
    required this.name,
    required this.description,
    required this.price,
  });
}

List<Product> products = [
  Product(
    name: 'Product 1',
    description: 'Description of Product 1',
    price: 10.99,
  ),
  Product(
    name: 'Product 2',
    description: 'Description of Product 2',
    price: 19.99,
  ),
  Product(
    name: 'Product 3',
    description: 'Description of Product 3',
    price: 15.49,
  ),
  Product(
    name: 'Product 4',
    description: 'Description of Product 4',
    price: 24.99,
  ),
  Product(
    name: 'Product 5',
    description: 'Description of Product 5',
    price: 12.79,
  ),
];

class CartItems extends StatelessWidget {
  const CartItems({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(products[index].name),
          subtitle: Text(products[index].description),
          trailing: Text('\$${products[index].price.toStringAsFixed(2)}'),
        );
      },
    );
  }
}

class MyCartContent extends StatelessWidget {
  const MyCartContent({
    super.key,
    required this.paymentResponseMessage,
  });

  final String? paymentResponseMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(child: CartItems()),
        const SizedBox(height: 20),
        if (paymentResponseMessage != null)
          Container(
            color: Colors.amber,
            padding: const EdgeInsets.all(10.0),
            child: Text(
              paymentResponseMessage!,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}
