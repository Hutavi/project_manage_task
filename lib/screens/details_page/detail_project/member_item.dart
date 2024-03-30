import 'package:flutter/material.dart';
import '../../../constants/color.dart';
import '../../../widgets/text_custom.dart';

class MemberItem extends StatelessWidget {
  const MemberItem({Key? key, required this.data}) : super(key: key);
  final Map<String, String> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: const BoxDecoration(
        color: COLOR_CARD_BACKGROUND,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(54),
              ),
            ),
            child: Image.asset(data['avatar'].toString()),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextCustom(
                text: data['name'].toString(),
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 5,
              ),
              TextCustom(
                text: data['role'].toString(),
                color: COLOR_TEXT_MAIN,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              TextCustom(
                text: data['mail'].toString(),
                color: COLOR_TEXT_MAIN,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ],
          )
        ],
      ),
    );
  }
}
