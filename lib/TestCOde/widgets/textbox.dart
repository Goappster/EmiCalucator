import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextBox extends StatelessWidget {
  final String label;
  final String helpertext;
  final TextEditingController tc;
  final IconData icon;

  TextBox({
    required this.label,
    required this.helpertext,
    required this.tc,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: tc,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: label.toUpperCase(),
        labelStyle: GoogleFonts.roboto(fontSize: 22, color: Colors.orange, fontWeight: FontWeight.bold),
        hintText: 'Type Here...',
        helperText: helpertext,
        hintStyle: GoogleFonts.openSans(fontSize: 18),
        suffixIcon: Icon(icon, color: Colors.black),
      ),
    );
  }
}
