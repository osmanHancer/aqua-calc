
import 'package:aquacalc/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class EditTextField extends StatefulWidget {
  final String name;
  final TextInputType textInputType;
  final int minLines, maxLines;
  final String? initialValue;
  final Function(String)? onChanged;


  const EditTextField({
    required this.name,
    this.textInputType = TextInputType.text,
    this.onChanged,
    this.initialValue,
    this.minLines = 1,
    this.maxLines = 1,
    super.key
  });

  @override
  State<EditTextField> createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  bool hasFocus = false;
  List<TextInputFormatter> formatters = [];

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (val) => setState(() => hasFocus = val),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 300,
          child: TextFormField(
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            initialValue: widget.initialValue ?? "",
            keyboardType: widget.textInputType,
            inputFormatters: formatters,
            onChanged: widget.onChanged,
            cursorColor: Utils.primaryColor,
            style: TextStyle(
              color: Utils.textColor,
              fontSize: 16
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Utils.foregroundColor,
              focusedBorder: const OutlineInputBorder(
                borderSide:  BorderSide(color: Utils.primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:  BorderSide(color: Utils.inactiveColor),
              ),
              labelText: widget.name,
              labelStyle: TextStyle(
                color: hasFocus ?  Utils.primaryColor : Utils.inactiveColor,
                fontSize: 18,
              )
            ),
          ),
        ),
      ),
    );
  }
}
