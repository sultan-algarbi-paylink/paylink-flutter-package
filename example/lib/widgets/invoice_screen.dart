import 'package:flutter/material.dart';
import 'package:paylink_payment_example/widgets/invoice_attribute.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({
    super.key,
    this.invoiceDetails,
    this.typeMsg,
    this.errorMsg,
  });

  final Map<String, dynamic>? invoiceDetails;
  final String? typeMsg, errorMsg;

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Invoice Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            /// --- Screen Resource Message
            if (widget.typeMsg != null)
              Text(
                widget.typeMsg!,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),

            /// --- Responce Error
            if (widget.errorMsg != null)
              Text(
                widget.errorMsg!,
                style: const TextStyle(color: Colors.red),
              ),

            /// --- Invoice Content
            if (widget.invoiceDetails != null)
              for (String attribute in [
                'transactionNo',
                'amount',
                'orderStatus'
              ])
                InvoiceAttribute(
                  attribute: attribute,
                  value: widget.invoiceDetails![attribute].toString(),
                ),
          ],
        ),
      ),
    );
  }
}
