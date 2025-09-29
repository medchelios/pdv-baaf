import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthPinField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleObscure;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const AuthPinField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.onToggleObscure,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      obscureText: obscureText,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
        LengthLimitingTextInputFormatter(8),
      ],
      enableSuggestions: false,
      autocorrect: false,
      textAlign: TextAlign.start,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: 'Code PDV',
        hintText: '••••••••',
        hintStyle: TextStyle(fontSize: 16, color: Colors.grey[400]),
        prefixIcon: const Icon(Icons.vpn_key),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggleObscure,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color(0xFFe94d29), width: 2),
        ),
        filled: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
    );
  }
}
