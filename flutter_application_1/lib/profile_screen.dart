//username and color/ability to choose color

import 'package:flutter/material.dart';

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

  void _editUsername() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _usernameController =
            TextEditingController(text: currentUsername);

        return AlertDialog(
          title: const Text("Edit Username"),
          content: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: "New Username",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            //Doesn't save for now
            TextButton(
              onPressed: () {
                setState(() {
                  currentUsername = _usernameController.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _editColor() {
    showDialog(
      context: context,
      builder: (context) {
        Color selectedColor = currentColor;
        //Subject to change
        return AlertDialog(
          title: const Text("Choose a Color"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ...[
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.orange,
                  Colors.purple,
                  Colors.pink,
                ].map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      width: 100,
                      height: 40,
                      color: color,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            //doesn't save either
            TextButton(
              onPressed: () {
                setState(() {
                  currentColor = selectedColor;
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Profile",
      )),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  //WIP
                  "Username: $currentUsername",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    currentUsername,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "Color: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 24,
                  height: 24,
                  color: currentColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
