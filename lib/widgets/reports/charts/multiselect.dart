import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class MultiCheckboxDropdown extends StatelessWidget {
  const MultiCheckboxDropdown(
      {super.key,
      required this.setStateFunc,
      required this.dropdownValues,
      required this.selectedValues});

  final Function setStateFunc;
  final List<String> dropdownValues;
  final List<String> selectedValues;

  @override
  Widget build(BuildContext context) {
    return DropDownMultiSelect(
      selected_values_style: const TextStyle(color: Colors.white),
      onChanged: (List<String> x) {
        setStateFunc(x);
      },
      options: dropdownValues,
      selectedValues: selectedValues,
      whenEmpty: 'Select Category',
    );
  }
}
