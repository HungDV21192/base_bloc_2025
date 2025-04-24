import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  TextStyles._();

  static TextStyle large = GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: Colors.white,
  );
  static TextStyle medium = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: Colors.white,
  );

  static TextStyle small = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: Colors.white,
  );
}
