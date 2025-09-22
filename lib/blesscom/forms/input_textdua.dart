import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextDua extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final bool enabled;
  final bool showCursor;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final ToolbarOptions? toolbarOptions;

  // tambahan khusus: bisa tangkap perubahan text
  final Function(String)? onChanged;

  const InputTextDua({
    this.label = "",
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.readOnly = false,
    this.enabled = true,
    this.showCursor = false,
    this.onTap,
    this.inputFormatters,
    this.keyboardType,
    this.toolbarOptions,
    this.onChanged, // baru
    Key? key,
  }) : super(key: key);

  @override
  _InputTextDuaState createState() => _InputTextDuaState();
}

class _InputTextDuaState extends State<InputTextDua> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        showCursor: widget.showCursor,
        onTap: widget.onTap,
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16),
          label: Text(widget.label),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
        ),
        obscureText: widget.obscureText,
        toolbarOptions: widget.toolbarOptions,
        onChanged: widget.onChanged, // penting biar bisa persist
      ),
    );
  }
}
