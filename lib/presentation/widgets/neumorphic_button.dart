import 'package:flutter/material.dart';

class NeumorphicButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;

  const NeumorphicButton({
    super.key,
    required this.child,
    this.onPressed,
    this.width = double.infinity,
    this.height = 50,
    this.backgroundColor = const Color(0xFFE0E5EC),
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    final isPressed = onPressed != null;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: isPressed
            ? [
                const BoxShadow(
                  color: Color(0xFFA3B1C6),
                  offset: Offset(4, 4),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
                const BoxShadow(
                  color: Color(0xFFFFFFFF),
                  offset: Offset(-4, -4),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ]
            : [
                const BoxShadow(
                  color: Color(0xFFA3B1C6),
                  offset: Offset(6, 6),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
                const BoxShadow(
                  color: Color(0xFFFFFFFF),
                  offset: Offset(-6, -6),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onPressed,
          child: Center(child: child),
        ),
      ),
    );
  }
}
