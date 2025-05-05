import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  const PasswordField(
      {super.key, required this.controller, required this.title});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obsureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obsureText,
      decoration: InputDecoration(
        hintText: widget.title,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: () {
            _obsureText = !_obsureText;
          },
          icon: Icon(_obsureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}
