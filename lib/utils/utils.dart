import 'package:flutter/material.dart';

class Utils {
  static Future<void> dialog(
      BuildContext context, Future<void> Function() process,
      [bool mounted = true]) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                // The loading indicator
                CircularProgressIndicator(),
                SizedBox(
                  height: 15,
                ),
                Text('Loading...')
              ],
            ),
          ),
        );
      },
    );
    await process();
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
