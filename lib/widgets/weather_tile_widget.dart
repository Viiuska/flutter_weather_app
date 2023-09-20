import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WeatherTileWidget extends StatelessWidget {
  BuildContext? context;
  String? title;
  double? titleFontSize;
  String? subTitle;

  WeatherTileWidget(
      {super.key, this.context, this.title, this.subTitle, this.titleFontSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(title ?? '',
              style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 100,
        ),
        Center(
          child: Text(subTitle ?? '',
              style: const TextStyle(fontSize: 14.0, color: Colors.white)),
        ),
      ],
    );
  }
}
