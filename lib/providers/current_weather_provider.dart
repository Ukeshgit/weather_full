import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:weather_app/common/services/api_helper.dart';

final currentWeatherProvider = FutureProvider.autoDispose((ref) async {
  return ApiHelper.getCurrentWeather();
});
