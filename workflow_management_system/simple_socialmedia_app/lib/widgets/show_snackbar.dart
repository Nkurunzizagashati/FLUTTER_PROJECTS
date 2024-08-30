import 'package:flutter/material.dart';

class CustomShowSnackbar extends StatelessWidget {
  final String error;

  const CustomShowSnackbar({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    // To show a Snackbar, it must be done within a function, not in the build method directly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
        ),
      );
    });

    return const SizedBox.shrink(); // Return an empty widget
  }
}
