//username and color/ability to choose color

import 'package:flutter/material.dart';
import 'package:gtk_flutter/app_state.dart';
import 'package:gtk_flutter/profile_colorpicker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key, required this.username, required this.userColor});

  String username;
  Color userColor;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String currentUsername;
  late Color currentColor;

  @override
  void initState() {
    super.initState();
    currentUsername = widget.username;
    currentColor = widget.userColor;
  }

  // Triggers color picker
  Future<void> _pickColor() async {
    final newColor = await showDialog<Color>(
      context: context,
      builder: (context) => ProfileColorPicker(initialColor: currentColor),
    );
    if (newColor != null) {
      setState(() {
        currentColor = newColor;
      });
      // Updates the color in the app state
      context.read<ApplicationState>().updateProfileColor(newColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 244, 181),
          title: const Text(
            "Profile",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          )),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Row(
              children: [
                Text(
                  "Username: $currentUsername",
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "Color: ",
                  style: TextStyle(fontSize: 30),
                ),
                GestureDetector(
                  onTap: _pickColor,
                  child: Container(
                      width: 50,
                      height: 50,
                      color: currentColor,
                      child: const IconButton(
                          onPressed: null,
                          icon: Icon(Icons.edit,
                              color: Color.fromARGB(255, 54, 54, 0)))),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
