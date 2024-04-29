import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({
    super.key,
    required this.paymentResponseMessage,
    required this.setCancelResponse,
  });

  final String paymentResponseMessage;
  final void Function(String) setCancelResponse;

  @override
  State<MyBottomNavigationBar> createState() => BExottomNavigationBarState();
}

class BExottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Colors.blue,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.paymentResponseMessage,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => widget.setCancelResponse(''),
                child: const Text(
                  'Clear',
                  style: TextStyle(color: Colors.yellow),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
