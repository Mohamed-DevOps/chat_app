import 'package:flutter/material.dart';

class InfoMessage extends StatelessWidget {
  const InfoMessage(
      {super.key,
      required this.message,
      required this.linkName,
      required this.onTap});

  final String message;
  final String linkName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            linkName,
            style: const TextStyle(
              color: Color(0xffc7ede6),
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
