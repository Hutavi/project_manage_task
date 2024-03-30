import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/models/user/user_model.dart';

import '../constants/font.dart';

class AssignmentItem extends StatelessWidget {
  const AssignmentItem({Key? key, required this.user, required this.remove})
      : super(key: key);

  final UserModel user;
  final void Function(UserModel value) remove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(100, 130, 255, 255),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: [
        InkWell(
          onTap: () {
            remove(user);
          },
          child: const Icon(
            Icons.close,
            color: Color.fromARGB(255, 0, 164, 234),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Text(
            user.user_name!,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: FONT_SIZE_TEXT_BUTTON,
              color: const Color.fromARGB(255, 0, 164, 234),
            ),
          ),
        )
      ]),
    );
  }
}
