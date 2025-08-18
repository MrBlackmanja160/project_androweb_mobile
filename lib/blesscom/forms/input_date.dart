import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class InputDate extends StatefulWidget {
  final DateTime? value;
  final String displayFormat;
  final String label;
  final String hint;
  final bool readOnly;
  final Function(DateTime?)? onChange;
  final FormFieldValidator<String>? validator;

  const InputDate({
    this.value,
    this.displayFormat = "d MMMM y",
    this.label = "",
    this.hint = "",
    this.readOnly = false,
    this.onChange,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  _InputDateState createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  DateTime? _selectedDate;

  void _showDatePicker() async {
    _selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 10),
          lastDate: DateTime(DateTime.now().year + 10),
        ) ??
        _selectedDate;

    // Trigger onchange
    if (widget.onChange != null) {
      widget.onChange!(_selectedDate);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    String text = "";
    if (_selectedDate != null) {
      text = DateFormat(widget.displayFormat).format(_selectedDate!);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        validator: widget.validator,
        controller: TextEditingController(text: text),
        showCursor: false,
        readOnly: true,
        enabled: !widget.readOnly,
        onTap: !widget.readOnly ? _showDatePicker : null,
        decoration: InputDecoration(
          hintText: widget.hint,
          label: Text(widget.label),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Icon(
              FontAwesomeIcons.calendar,
              size: 18,
            ),
          ),
          contentPadding: const EdgeInsets.only(left: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
