import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather_app/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'widgets/forecast_tile_widget.dart';
import 'widgets/info_widget.dart';
import 'widgets/weather_tile_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: tdBlue));
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(title: 'Hello'));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                tileMode: TileMode.clamp,
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
                colors: [tdBlue, tlBlue])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            WeatherTileWidget(
                context: context,
                title: 'Helsinki',
                titleFontSize: 30.0,
                subTitle: DateFormat('dd-MMM-yyyy').format(DateTime.now())),
            Center(
              child: CachedNetworkImage(
                imageUrl: 'http://openweathermap.org/img/wn/11d@4x.png',
                height: 200,
                width: 200,
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, err) => const Icon(
                  Icons.image,
                  color: Colors.white,
                ),
              ),
            ),
            WeatherTileWidget(
                context: context,
                title: '16 °C',
                titleFontSize: 60.0,
                subTitle: 'Light Rain'),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 8,
                ),
                InfoWidget(icon: FontAwesomeIcons.wind, text: '10'),
                InfoWidget(icon: FontAwesomeIcons.cloud, text: '10'),
                InfoWidget(icon: FontAwesomeIcons.snowflake, text: '10'),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 8,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
                child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ForecastTileWidget(temp: '25 °C', time: '15:00'),
                ForecastTileWidget(temp: '25 °C', time: '15:00'),
                ForecastTileWidget(temp: '25 °C', time: '15:00'),
                ForecastTileWidget(temp: '25 °C', time: '15:00')
              ],
            ))
          ],
        ),
      )),
    );
  }
}
