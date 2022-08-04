// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/weather_bloc.dart';
import 'weather_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController textController;
  final errorMessage = 'Введите название города';
  String? errorText;

  @override
  void initState() {
    textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(40),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  errorText: errorText,
                ),
                onChanged: (val) {
                  val.isEmpty ? errorText = errorMessage : errorText = null;
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  BlocProvider.of<WeatherBloc>(context).add(WeatherEvent.weatherRequested(cityName: textController.text));
                  Navigator.of(context).push(
                    MaterialPageRoute<Widget>(
                      builder: (context) => const WeatherDetailsScreen(),
                    ),
                  );
                } else {
                  setState(() {
                    errorText = errorMessage;
                  });
                }
              },
              child: const Text('Подтвердить'),
            )
          ],
        ),
      ),
    );
  }
}
