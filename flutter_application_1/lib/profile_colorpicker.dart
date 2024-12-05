import 'package:flutter/material.dart';

class ProfileColorPicker extends StatefulWidget {
  final Color initialColor;

  const ProfileColorPicker({super.key, required this.initialColor});

  @override
  State<ProfileColorPicker> createState() => _ProfileColorPickerState();
}

class _ProfileColorPickerState extends State<ProfileColorPicker> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Choose a Color"),
      content: DropdownButton<Color>(
        value: selectedColor,
        items: const [
          DropdownMenuItem(
            value: Colors.red,
            child: Text("Red", style: TextStyle(color: Colors.red)),
          ),
          DropdownMenuItem(
            value: Colors.orange,
            child: Text("Orange", style: TextStyle(color: Colors.orange)),
          ),
          DropdownMenuItem(
            value: Colors.yellow,
            child: Text("Yellow", style: TextStyle(color: Colors.yellow)),
          ),
          DropdownMenuItem(
            value: Colors.green,
            child: Text("Green", style: TextStyle(color: Colors.green)),
          ),
          DropdownMenuItem(
            value: Colors.blue,
            child: Text("Blue", style: TextStyle(color: Colors.blue)),
          ),
          DropdownMenuItem(
            value: Colors.purple,
            child: Text("Purple", style: TextStyle(color: Colors.purple)),
          ),
        ],
        onChanged: (Color? value) {
          setState(() {
            if (value != null) {
              selectedColor = value;
            }
          });
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedColor);
          },
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
