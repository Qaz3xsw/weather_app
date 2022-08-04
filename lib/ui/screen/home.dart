import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/ui/screen/weather_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController textController;
  String? errorText;

  @override
  void initState() {
    textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  val.isEmpty ? errorText = 'error' : errorText = null;
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  BlocProvider.of<WeatherBloc>(context).add(WeatherEvent.weatherRequested(cityName: textController.text));
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const WeatherDetailsScreen(),
                  ));
                } else {
                  setState(() {
                    errorText = 'error';
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
