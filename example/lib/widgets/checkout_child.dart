import 'package:flutter/material.dart';

class MyCheckoutContent extends StatelessWidget {
  const MyCheckoutContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.blue,
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Checkout',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 24.0),
          ),
          SizedBox(width: 5),
          Icon(Icons.add, color: Colors.white),
        ],
      ),
    );
  }
}
