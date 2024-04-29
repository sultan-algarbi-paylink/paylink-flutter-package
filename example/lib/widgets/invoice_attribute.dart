import 'package:flutter/material.dart';

class InvoiceAttribute extends StatelessWidget {
  const InvoiceAttribute(
      {super.key, required this.attribute, required this.value});

  final String attribute, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 20.0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  attribute,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Expanded(flex: 7, child: Text(value)),
            ],
          ),
        ],
      ),
    );
  }
}
