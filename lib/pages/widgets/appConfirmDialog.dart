import 'package:flutter/material.dart';

class AppConfirmDialog extends StatefulWidget {
  final String title;
  const AppConfirmDialog({super.key, required this.title});


  static show(BuildContext context,{String title = "Are you sure ?"}) async {
    return await showDialog(context: context, builder: (context){
      return AppConfirmDialog(title: title,);
    });
  }

  @override
  State<AppConfirmDialog> createState() => _AppConfirmDialogState();
}

class _AppConfirmDialogState extends State<AppConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        widget.title,
        style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: const SizedBox(
        height: 0, // optional, can add a message if needed
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[800],
            textStyle: textTheme.bodyMedium?.copyWith(fontSize: 16),
          ),
          child: const Text("No"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text("Yes"),
        ),
      ],
    );
  }
}
