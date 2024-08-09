import 'package:flutter/material.dart';

class DialogConfirmation extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onYesTap;
  final VoidCallback onNoTap;

  const DialogConfirmation({
    Key? key,
    required this.title,
    required this.content,
    required this.onYesTap,
    required this.onNoTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
      content: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black45,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: onYesTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.brown, borderRadius: BorderRadius.circular(5)),
            child: const Text(
              'Yes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: onNoTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.brown,
              ),
            ),
            child: const Text(
              'No',
              style: TextStyle(
                color: Colors.brown,
                fontSize: 14,
              ),
            ),
          ),
        )
      ],
    );
  }
}
