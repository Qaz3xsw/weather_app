// ignore_for_file: avoid_types_on_closure_parameters, lines_longer_than_80_chars

import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../model/weather.dart';
import 'errors.dart';

part 'weather_bloc.freezed.dart';

abstract class IWeatherRepository {
  Future<Weather> requestWeatherByCity(String cityName);
}

/// Events
@freezed
class WeatherEvent with _$WeatherEvent {
  const WeatherEvent._();
  const factory WeatherEvent.weatherRequested({required String cityName}) = _WeatherRequested;
}

/// States
@freezed
class WeatherState with _$WeatherState {
  const WeatherState._();
  const factory WeatherState.initial() = _Initial;
  const factory WeatherState.inProgress() = _InProgress;
  const factory WeatherState.loaded(Weather weather) = _Loaded;
  const factory WeatherState.error(String errorMsg) = _Error;
}

/// Bloc
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({
    required this.weatherRepository,
  }) : super(const WeatherState.initial()) {
    on<WeatherEvent>((event, emit) {
      return event.map<Future<void>>(
        weatherRequested: (_WeatherRequested event) => _getWeather(event, emit),
      );
    });
  }

  final IWeatherRepository weatherRepository;

  Future<void> _getWeather(_WeatherRequested event, Emitter<WeatherState> emit) async {
    emit(const WeatherState.inProgress());

    try {
      final Weather weather = await weatherRepository.requestWeatherByCity(event.cityName);
      emit(WeatherState.loaded(weather));

      /// Handle errors somehow, i.e send them somewhere
    } on CityNotExistsException catch (e) {
      emit(WeatherState.error('Город ${e.cityName} не существует!'));
    } on SocketException catch (e, trace) {
      emit(const WeatherState.error('Нет сети'));
      log(e.message, stackTrace: trace);

      /// Bad JSON
    } on FormatException catch (e, trace) {
      emit(const WeatherState.error('Не предвиденная ошибка'));
      log(e.message, stackTrace: trace);

      /// Bad response
    } on ResponseCodeException catch (e) {
      if (e.codeType == CodeType.http && e.code == 500) {
        emit(const WeatherState.error('Ошибка сервера'));
        log(e.message, error: e);
        return;
      }

      if (e.code == 401) {
        emit(const WeatherState.error('Доступ запрещен'));
        log(e.message, error: e);
        return;
      }

      // other codes handling..
      emit(const WeatherState.error('Что-то пошло не так..'));
      log('unknown response error', error: e);

      /// Unexpected
    } on Exception catch (e, trace) {
      emit(const WeatherState.error('Не предвиденная ошибка'));
      log('unexpected', stackTrace: trace);
    }
  }
}
