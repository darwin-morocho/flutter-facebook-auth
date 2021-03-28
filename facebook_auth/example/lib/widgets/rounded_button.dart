import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final Color textColor, backgroundColor, borderColor;
  final bool fullWidth;
  final EdgeInsets padding;
  final double? fontSize;
  const RoundedButton({
    Key? key,
    @required this.onPressed,
    required this.label,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.blue,
    this.borderColor = Colors.blue,
    this.fullWidth = true,
    this.padding = const EdgeInsets.symmetric(vertical: 9, horizontal: 30),
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Container(
        width: this.fullWidth ? double.infinity : null,
        padding: this.padding,
        decoration: BoxDecoration(
          color: this.backgroundColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            width: 1.4,
            color: this.borderColor,
          ),
        ),
        child: Text(
          this.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: this.textColor,
            fontSize: this.fontSize,
          ),
        ),
      ),
      minSize: 30,
      padding: EdgeInsets.zero,
      onPressed: this.onPressed,
    );
  }
}
