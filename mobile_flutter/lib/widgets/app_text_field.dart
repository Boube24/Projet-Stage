import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController controller;

  final String label;

  final String? hint;

  final IconData? prefixIcon;

  final TextInputType keyboardType;

  final String? Function(String?)? validator;

  final bool obscureText;

  final int maxLines;

  final bool enabled;

  final bool readOnly;

  final VoidCallback? onTap;

  @override
  State<AppTextField> createState() =>
      _AppTextFieldState();
}

class _AppTextFieldState
    extends State<AppTextField> {

  late bool _obscure;

  @override
  void initState() {
    super.initState();

    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {

    return TextFormField(

      controller: widget.controller,

      keyboardType: widget.keyboardType,

      validator: widget.validator,

      obscureText: _obscure,

      maxLines:
      widget.obscureText
          ? 1
          : widget.maxLines,

      enabled: widget.enabled,

      readOnly: widget.readOnly,

      onTap: widget.onTap,

      decoration: InputDecoration(

        labelText: widget.label,

        hintText: widget.hint,

        prefixIcon:
        widget.prefixIcon != null
            ? Icon(widget.prefixIcon)
            : null,

        border:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
        ),

        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        suffixIcon:
        widget.obscureText
            ? IconButton(
          icon: Icon(
            _obscure
                ? Icons.visibility
                : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        )
            : null,
      ),
    );
  }
}