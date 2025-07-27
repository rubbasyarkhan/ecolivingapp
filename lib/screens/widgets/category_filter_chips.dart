// import 'package:flutter/material.dart';

// class CategoryFilterChips extends StatelessWidget {
//   final List<String> options;
//   final String selected;
//   final ValueChanged<String> onSelected;

//   const CategoryFilterChips({
//     Key? key,
//     required this.options,
//     required this.selected,
//     required this.onSelected,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 10,
//       children: options.map((option) {
//         final bool isSelected = option == selected;
//         return ChoiceChip(
//           label: Text(option),
//           selected: isSelected,
//           onSelected: (_) => onSelected(option),
//           selectedColor: Colors.green.shade200,
//           backgroundColor: Colors.grey.shade200,
//           labelStyle: TextStyle(
//             color: isSelected ? Colors.green[900] : Colors.black87,
//             fontWeight: FontWeight.w500,
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
