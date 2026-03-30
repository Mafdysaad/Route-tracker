import 'package:flutter/material.dart';

class Customtextfiled extends StatelessWidget {
  const Customtextfiled({super.key, required this.textEditingController});
  final TextEditingController? textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.location_on_outlined, size: 24),
        fillColor: Colors.white,
        filled: true,
        hint: Text('Sarch here !'),
        contentPadding: EdgeInsets.all(6),
        hintStyle: TextStyle(
          color: const Color.fromARGB(255, 41, 40, 40),
          fontSize: 24,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
