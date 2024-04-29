import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    required this.addInvoiceAction,
  });

  final void Function() addInvoiceAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Text(
        'Payment Demo',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: addInvoiceAction,
          child: const Text(
            'Add Invoice',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
