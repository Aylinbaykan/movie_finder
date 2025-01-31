import 'package:flutter/material.dart';

class CustomToggleButtons extends StatefulWidget {
  final List<String> options;
  final String selectedOption;
  final Function(String) onSelected;

  const CustomToggleButtons({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
  });

  @override
  _CustomToggleButtonsState createState() => _CustomToggleButtonsState();
}

class _CustomToggleButtonsState extends State<CustomToggleButtons> {
  late String _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: widget.options.map((option) {
                  bool isSelected = _selectedOption == option;

                  return GestureDetector(
                    onTap: () {
                      _selectedOption = option;
                      widget.onSelected(option);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Colors.blueAccent : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.grey.shade400,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )));
  }
}
