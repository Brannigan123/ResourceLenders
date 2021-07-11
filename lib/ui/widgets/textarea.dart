import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:layout/layout.dart';
import 'package:sizer/sizer.dart';

class TextArea extends StatefulWidget {
  const TextArea({
    Key? key,
    this.focusNode,
    this.controller,
    this.action,
    this.inputType,
    required this.label,
    this.labelGroup,
    this.placeholder,
    this.editable = true,
    this.obscure = false,
    this.onSubmitted,
    this.onChanged,
    this.onEditingComplete,
  }) : super(key: key);

  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputAction? action;
  final TextInputType? inputType;
  final String label;
  final String? placeholder;
  final AutoSizeGroup? labelGroup;
  final bool editable;
  final bool obscure;
  final void Function(String val)? onSubmitted;
  final void Function(String val)? onChanged;
  final VoidCallback? onEditingComplete;

  @override
  _TextAreaState createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  late final ValueNotifier<bool> obscured;

  @override
  void initState() {
    super.initState();
    obscured = ValueNotifier(widget.obscure);
  }

  @override
  void dispose() {
    obscured.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ValueListenableBuilder<bool>(
        valueListenable: obscured,
        builder: (context, hidden, child) => AutoSizeTextField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          textInputAction: widget.action,
          keyboardType: widget.inputType,
          enabled: widget.editable,
          textAlign: TextAlign.left,
          cursorColor: Color(0xffA8B3Bd),
          obscureText: hidden,
          onSubmitted: widget.onSubmitted,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          maxLines: 1,
          minFontSize: 8.0,
          style: TextStyle(
            color: Color(0xffA8B3Bd),
            fontWeight: FontWeight.w600,
            fontSize: 6.5.sp,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xff1B213E),
            contentPadding: EdgeInsets.all(0.25 * context.layout.gutter),
            hintText: widget.placeholder,
            hintStyle: TextStyle(
              color: Color(0xffA8B3Bd),
              fontWeight: FontWeight.w600,
              fontSize: 6.5.sp,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff2765FF), width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            prefixIcon: SizedBox(
              width: 0.30 * constraints.minWidth,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 0.35 * context.layout.gutter,
                  horizontal: 0.55 * context.layout.gutter,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    gradient: LinearGradient(
                      colors: [Color(0xff163458), Color(0xff242b5c)],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: context.layout.gutter / 4.0,
                        horizontal: context.layout.gutter / 3.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: AutoSizeText(
                        widget.label,
                        group: widget.labelGroup,
                        minFontSize: 8.0,
                        style: TextStyle(
                          color: Color(0xff76A9EA),
                          fontSize: 6.0.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            suffixIcon: widget.obscure
                ? GestureDetector(
                    onTap: () => obscured.value = !obscured.value,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Padding(
                        padding: EdgeInsets.all(0.3 * context.layout.gutter),
                        child: Icon(
                          hidden ? Icons.visibility_off : Icons.visibility,
                          color: hidden ? Color(0xffA8B3Bd) : Color(0xff76A9EA),
                          size: 0.75 * context.layout.gutter,
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
