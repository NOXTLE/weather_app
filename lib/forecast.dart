import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  Tile({required this.time, required this.icon, required this.temp, super.key});
  String time;
  String temp;
  IconData icon;

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.time,
                maxLines: 1,
              ),
              const SizedBox(height: 10),
              Icon(widget.icon),
              const SizedBox(
                height: 10,
              ),
              Text(widget.temp),
            ],
          ),
        ),
      ),
    );
  }
}
