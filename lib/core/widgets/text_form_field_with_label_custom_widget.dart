import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFormFieldWithLabelCustomWidget extends StatefulWidget {
  final TextInputType keyboardType;
  final String? hintText;
  bool obscureText;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?) validator;
  final String? labelText;
  final Widget? beforeIconAsset;
  final void Function(String)? onChanged;
  
  TextFormFieldWithLabelCustomWidget({
    this.controller,
    required this.validator,
    this.labelText,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isPassword = false,
    this.beforeIconAsset,
    this.onChanged,
    super.key,
  });

  @override
  State<TextFormFieldWithLabelCustomWidget> createState() => _TextFormFieldWithLabelCustomWidgetState();
}

class _TextFormFieldWithLabelCustomWidgetState extends State<TextFormFieldWithLabelCustomWidget> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.labelText == null ? const SizedBox() : Text(widget.labelText!,style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xff24252C)
        ),),
        TextFormField(
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            overflow: TextOverflow.ellipsis,
          ),
          obscureText: widget.obscureText,
        
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
              overflow: TextOverflow.ellipsis,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      widget.obscureText ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xff454A4F),
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.obscureText = !widget.obscureText;
                      });
                    },
                  )
                : null,
            prefixIcon: widget.beforeIconAsset,
            contentPadding: const EdgeInsets.all(15),
            enabledBorder: outlineInputBorder(
              color: Color(0xffBABABA),
              radius: 10,
              width: 1,
            ),
            focusedBorder: outlineInputBorder(
              color: Color(0xff5F33E1),
              radius: 10,
              width: 1,
            ),
            errorBorder: outlineInputBorder(
              color: Colors.red,
              radius: 10,
              width: 1,
            ),
            focusedErrorBorder: outlineInputBorder(
              color: Colors.red,
              radius: 10,
              width: 1,
            ),
          ),
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }

  OutlineInputBorder outlineInputBorder({
    required double radius,
    required Color color,
    required double width,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}