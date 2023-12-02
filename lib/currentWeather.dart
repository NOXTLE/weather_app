import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'forecast.dart';
import 'package:flutter/material.dart';
import 'additional.dart';
import 'package:http/http.dart' as http;

class currentWeather extends StatefulWidget {
  const currentWeather({super.key});

  State<currentWeather> createState() {
    return _currentWeatherState();
  }
}

int index = 5;
String Location = "London";
TextEditingController tc = TextEditingController();

class _currentWeatherState extends State<currentWeather> {
  Future<Map> getCurrentWeather() async {
    final res = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/forecast?q=$Location&APPID=625ff3139579f58c89ce906c679356a8'));

    final weather = jsonDecode(res.body);

    return weather;
  }

  @override
  Widget build(context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.pin_drop),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("ENTER LOCATION"),
                        const SizedBox(height: 10),
                        TextField(
                          controller: tc,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                Location = tc.text;
                                tc.text = "";
                                Navigator.of(context).pop();
                              });
                            },
                            child: const Text("Submit"))
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        appBar: AppBar(
          centerTitle: true,
          title: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: SizedBox(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("ENTER LOCATION"),
                          const SizedBox(height: 10),
                          TextField(
                            controller: tc,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Location = tc.text;
                                  tc.text = "";
                                  Navigator.of(context).pop();
                                });
                              },
                              child: const Text("Submit"))
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Text(
              "$Location ⏑",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              focusColor: Colors.brown,
              splashColor: Colors.white,
              onPressed: () {
                setState(() {});
              },
            )
          ],
        ),
        body: Container(
          child: FutureBuilder(
            future: getCurrentWeather(),
            builder: (context, snapshot) {
              //snapshot handles states waiting error and running states
              print(snapshot);
              print(snapshot.runtimeType);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                );
              }

              final data = snapshot.data! as Map<String,
                  dynamic>; //typecasting of object data into map;

              final currentTemp = data['list'][0]['main']['temp'] - 273.15;

              final currentTem = currentTemp.toStringAsFixed(2);

              final weatherz = data['list'][0]['weather'][0]['main'];

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    //maincard
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 220,
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          shadowColor: Colors.black,
                          borderOnForeground: true,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Text(
                                    '$currentTem℃',
                                    style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Icon(
                                    weatherz == "Clouds"
                                        ? Icons.cloud
                                        : weatherz == "Rain"
                                            ? Icons.water_drop_sharp
                                            : Icons.sunny,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    weatherz,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    //weather forecast card

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Weather Forecast',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //forecast card

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 8,
                            itemBuilder: (context, index) {
                              final dateTime = DateTime.parse(
                                  data['list'][index + 1]['dt_txt']);
                              return Tile(
                                time: DateFormat.Hm().format(dateTime),
                                icon: data['list'][index + 1]['weather'][0]
                                            ['main'] ==
                                        "Clouds"
                                    ? Icons.cloud
                                    : data['list'][0]['weather'][0]['main'] ==
                                            "Rain"
                                        ? Icons.water_drop_rounded
                                        : Icons.sunny,
                                temp: (data['list'][index + 1]['main']['temp'] -
                                        273.15)
                                    .toStringAsFixed(2),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 70),
                    //additional information card
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Additional Information',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          additional(
                              weather: 'Humidity',
                              weatherIcon: const Icon(Icons.water_drop),
                              weatherdata: data['list'][0]['main']['humidity']
                                  .toString()),
                          additional(
                              weather: 'wind Speed',
                              weatherIcon: const Icon(Icons.air_outlined),
                              weatherdata:
                                  (data['list'][0]['wind']['gust'] * 1.609344)
                                      .toStringAsFixed(2)),
                          additional(
                              weather: 'pressure',
                              weatherIcon: const Icon(Icons.speed),
                              weatherdata: data['list'][0]['main']['pressure']
                                  .toString())
                        ]),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
