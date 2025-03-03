import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/app.dart';
import 'package:flutter_weather/weather_bloc_observer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_repository/weather_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const WeatherBlocObserver();
  /*
      HydratedBloc
        flutter_bloc 패키지의 확장 기능.
        Bloc이나 Cubit의 상태를 로컬 스토리지에 저장하고 앱이 재시작 되거나 복원될 대 자동으로 해당 상태를 복구.
   */
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  runApp(WeatherApp(weatherRepository: WeatherRepository()));
}
