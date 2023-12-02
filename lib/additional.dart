import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class additional extends StatefulWidget {
  additional(
      {required this.weather,
      required this.weatherIcon,
      required this.weatherdata,
      super.key});
  String weather;
  Icon weatherIcon;
  String weatherdata;
  @override
  State<additional> createState() => _additionalState();
}

class _additionalState extends State<additional> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(children: [
          Text(widget.weather,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
          const SizedBox(
            height: 5,
          ),
          widget.weatherIcon,
          const SizedBox(
            height: 5,
          ),
          Text("${widget.weatherdata}")
        ]),
      ),
    );
  }
}
