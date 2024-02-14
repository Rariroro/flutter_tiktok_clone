import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constants/sizes.dart';

class FormButton extends StatelessWidget {
  const FormButton({
    super.key,
    required this.disabled,
    this.buttonText,
  });
  final bool disabled;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.size20),
          color:
              disabled ? Colors.grey.shade300 : Theme.of(context).primaryColor,
        ),
        duration: const Duration(milliseconds: 500),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          style: TextStyle(
            color: disabled ? Colors.grey.shade400 : Colors.white,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          child: buttonText == null ? const Text("Next") : Text('$buttonText'),
        ),
      ),
    );
  }
}
