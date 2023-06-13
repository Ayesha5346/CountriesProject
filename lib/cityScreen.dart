import 'package:flutter/material.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({
    super.key,
    required this.city,
  });
  final List<String> city;
  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cities'),
      ),
      body: ListView.builder(
          itemCount: widget.city.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(widget.city[index]),
            );
          }),
    );
  }
}
