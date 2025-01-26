import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise/widgets/constants.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    required this.onChanged,
    required this.value,
    required this.list,
    this.hintText,
    this.expanded = false,
    this.hintTextColor = Colors.grey,
    this.textColor,
    this.borderRadius = 30,
    this.borderColor,
    this.borderWidth = 1.0,
    this.padding,
    super.key,
  });

  final String? hintText;
  final String? value;
  final List<String> list;
  final bool expanded;
  final void Function(String?)? onChanged;
  final Color? textColor;
  final double borderRadius;
  final Color? borderColor;
  final Color hintTextColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      // margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.black),
        color: theme.scaffoldBackgroundColor,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          isExpanded: expanded,
          value: value,
          hint: hintText != null
              ? Text(
                  hintText!,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: hintTextColor,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
          underline: Container(color: Colors.transparent),
          onChanged: onChanged,
          iconStyleData: const IconStyleData(
              icon: Icon(
            Icons.expand_more,
            color: PrimaryColor,
            weight: 10,
          )),
          items: list
              .map<DropdownMenuItem<String>>(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      e,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: textColor ?? theme.colorScheme.onSurface,
                            // Prevents text from wrapping
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
