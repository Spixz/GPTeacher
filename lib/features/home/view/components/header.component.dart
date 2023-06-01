import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpteacher/constants/colors.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.mateSc(
            //mateSc notoSerifTelugu
            textStyle: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: oldTitleColor,
        )),
        children: const <TextSpan>[
          TextSpan(
            text: 'GPT', /*style: TextStyle(color: secondaryColor)*/
          ),
          TextSpan(text: 'eacher'),
        ],
      ),
    );
  }
}
