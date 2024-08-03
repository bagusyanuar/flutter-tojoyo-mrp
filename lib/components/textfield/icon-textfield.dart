import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

typedef FunctionStringCallback = Function(String params);

class TextfieldIcon extends StatelessWidget {
  final FunctionStringCallback onChanged;
  final IconData icon;
  final String placeholder;

  const TextfieldIcon({
    Key? key,
    required this.onChanged,
    this.icon = Icons.circle_outlined,
    this.placeholder = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        onChanged(value);
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        prefixIcon: Icon(icon),
        hintText: placeholder,
      ),
    );
  }
}
