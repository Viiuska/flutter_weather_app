//Source: https://www.youtube.com/watch?v=I-Z5xiSJ9cw
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather_app/constants/colors.dart';
import 'package:flutter_weather_app/constants/models/forecast_result.dart';
import 'package:flutter_weather_app/constants/models/weather_result.dart';
import 'package:flutter_weather_app/network/open_weather_map_client.dart';
import 'package:flutter_weather_app/state/state.dart';
import 'package:flutter_weather_app/utils/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

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
  final controller = Get.put(MyStateController());
  var location = Location();
  late StreamSubscription listener;
  late PermissionStatus permissionStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
      await enableLocationListener();
    });
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    tileMode: TileMode.clamp,
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                    colors: [tdBlue, tlBlue])),
            child: controller.locationData.value.latitude != null
                ? FutureBuilder(
                    future: OpenWeatherMapClient()
                        .getWeather(controller.locationData.value),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return const Center(
                          child: Text('No data',
                              style: TextStyle(color: Colors.white)),
                        );
                      } else {
                        var data = snapshot.data as WeatherResult;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 20,
                            ),
                            WeatherTileWidget(
                                context: context,
                                title: (data.name != null &&
                                        data.name!.isNotEmpty)
                                    ? data.name
                                    : '${data.coord!.lat}/${data.coord!.lon}',
                                titleFontSize: 30.0,
                                subTitle: DateFormat('dd-MMM-yyyy').format(
                                    DateTime.fromMicrosecondsSinceEpoch(
                                        (data.dt ?? 0) * 1000))),
                            Center(
                              child: CachedNetworkImage(
                                imageUrl:
                                    buildIcon(data.weather![0].icon ?? ''),
                                height: 200,
                                width: 200,
                                fit: BoxFit.fill,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        const CircularProgressIndicator(),
                                errorWidget: (context, url, err) => const Icon(
                                  Icons.image,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            WeatherTileWidget(
                                context: context,
                                title: '${data.main!.temp!.round()}°C',
                                titleFontSize: 60.0,
                                subTitle: '${data.weather![0].description}'),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 8,
                                ),
                                InfoWidget(
                                    icon: FontAwesomeIcons.wind,
                                    text: '${data.wind!.speed}'),
                                InfoWidget(
                                    icon: FontAwesomeIcons.cloud,
                                    text: '${data.clouds!.all}'),
                                InfoWidget(
                                    icon: FontAwesomeIcons.snowflake,
                                    text: data.snow != null
                                        ? '${data.snow!.d1h}'
                                        : '0'),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 8,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Expanded(
                                child: FutureBuilder(
                              future: OpenWeatherMapClient()
                                  .getForecast(controller.locationData.value),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      snapshot.error.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  );
                                } else if (!snapshot.hasData) {
                                  return const Center(
                                    child: Text('No data',
                                        style: TextStyle(color: Colors.white)),
                                  );
                                } else {
                                  var data = snapshot.data as ForecastResult;
                                  return ListView.builder(
                                    itemCount: data.list!.length ?? 0,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      var item = data.list![index];
                                      return ForecastTileWidget(
                                          imageUrl: buildIcon(
                                              item.weather![0].icon ?? '',
                                              isBigSize: false),
                                          temp: '${item.main!.temp!.round()}°C',
                                          time: DateFormat('HH:mm').format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      (item.dt ?? 0) * 1000)));
                                    },
                                  );
                                }
                              },
                            ))
                          ],
                        );
                      }
                    },
                  )
                : const Center(
                    child: Text('Waiting...',
                        style: TextStyle(color: Colors.white)),
                  ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          controller.locationData.value = await location.getLocation();
        },
        child: const Icon(
          Icons.refresh,
        ),
        backgroundColor: const Color.fromARGB(255, 97, 127, 145),
      ),
    );
  }

  Future<void> enableLocationListener() async {
    controller.isEnableLocation.value = await location.serviceEnabled();
    if (!controller.isEnableLocation.value) {
      controller.isEnableLocation.value = await location.requestService();
      if (!controller.isEnableLocation.value) {
        return;
      }
    }
    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    controller.locationData.value = await location.getLocation();
    listener = location.onLocationChanged.listen((event) {});
  }
}
