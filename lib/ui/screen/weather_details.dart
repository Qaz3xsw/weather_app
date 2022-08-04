import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/model/weather.dart';

class WeatherDetailsScreen extends StatelessWidget {
  const WeatherDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return BlocConsumer<WeatherBloc, WeatherState>(
                listener: (context, state) {
                  state.whenOrNull(error: (String errorMsg) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          bottom: (constraints.maxHeight / 2),
                          left: 20,
                          right: 20,
                        ),
                        content: Text(errorMsg),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  });
                },
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => const CircularProgressIndicator(strokeWidth: 2),
                    loaded: (Weather weather) {
                      return SizedBox(
                        height: 100,
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Температура'),
                                Text(weather.basic.temperature.toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Влажность'),
                                Text(weather.basic.humidity.toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Скорость ветра'),
                                Text(weather.wind.speed.toString()),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    error: (String errorMsg) {
                      return const Text('Произошла ошибка');
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
