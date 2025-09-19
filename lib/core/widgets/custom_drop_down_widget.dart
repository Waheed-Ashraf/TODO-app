import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:farmedia/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDropDownWidget extends StatefulWidget {
  final void Function(Object?)? onSaved;
  final void Function(Object?)? onChanged;
  final List<DropdownMenuItem<Object>> items;
  final String hintText;
  final Color? textFieldBorderColor;

  const CustomDropDownWidget({
    super.key,
    this.onSaved,
    this.onChanged,
    required this.items,
    required this.hintText,
    this.textFieldBorderColor,
  });

  @override
  State<CustomDropDownWidget> createState() => _CustomDropDownWidgetState();
}

class _CustomDropDownWidgetState extends State<CustomDropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<Object>(
      isExpanded: true,
      decoration: InputDecoration(
        counterText: "",
        filled: true,
        fillColor: Colors.grey.shade200,
        hintText: widget.hintText,
        hintStyle: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: Colors.black.withOpacity(.45)),
        contentPadding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: widget.textFieldBorderColor ?? Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
        iconSize: 24,
      ),
      items: widget.items,
      validator: (value) {
        if (value == null) {
          return 'Please select an option.';
        }
        return null;
      },
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
