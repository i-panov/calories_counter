import 'package:flutter/material.dart';

Future<bool> confirm(BuildContext context, String message) async {
  return await showAdaptiveDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Да'),
        ),
      ],
    ),
  ) ?? false;
}
