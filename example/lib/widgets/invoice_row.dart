import 'package:flutter/material.dart';

class InvoiceRow extends StatelessWidget {
  const InvoiceRow({
    super.key,
    required this.invoice,
    required this.getInvoice,
    required this.checkout,
    required this.cancelInvoice,
  });

  final Map<String, dynamic> invoice;
  final void Function(String) getInvoice, checkout, cancelInvoice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(invoice['label']),
              Text(invoice['transactionNo']),
            ],
          ),
          TextButton(
            onPressed: () => getInvoice(invoice['transactionNo']),
            child: const Text('Get Invoice'),
          ),
          TextButton(
            onPressed: () => checkout(invoice['transactionNo']),
            child: const Text('Checkout'),
          ),
          TextButton(
            onPressed: () => cancelInvoice(invoice['transactionNo']),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
