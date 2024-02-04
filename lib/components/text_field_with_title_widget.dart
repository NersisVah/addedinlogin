import 'package:flutter/material.dart';

class TextFieldWithTitle extends StatelessWidget {
  final String value;
  final String? errorText;
  final Function(String?) onChanged;
  final Function(String?) validate;
  final bool? isValid;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Widget? suffixIcon;

  TextFieldWithTitle(
      { this.errorText ,this.suffixIcon , this.keyboardType ,this.obscureText ,  this.isValid, required this.value, required this.onChanged, required this.validate });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 18.0),
          ),
          const SizedBox(
            height: 5.0,
          ),
          TextField(
            obscureText: obscureText??false,
            keyboardType: keyboardType??TextInputType.text,
            onChanged:(inputText){
              validate(inputText);
              onChanged(inputText);
              },
            decoration: InputDecoration(

              suffixIcon: suffixIcon,
              hintText: value,
              errorText: (isValid ?? true) ? null : errorText,
              errorStyle: TextStyle(),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 3.5),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.5),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
