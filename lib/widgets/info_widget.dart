import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class InfoWidget extends StatelessWidget {
  IconData? icon;
  String? text;

  InfoWidget({super.key, this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FaIcon(icon, color: Colors.white),
        const SizedBox(
          height: 10,
        ),
        Text(text ?? '', style: const TextStyle(color: Colors.white))
      ],
    );
  }
}
