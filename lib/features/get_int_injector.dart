import 'package:get_it/get_it.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingletonAsync<Mixpanel>(() => Mixpanel.init(
      "0c327382d0e0f0e8aa435afbf202367e",
      trackAutomaticEvents: true));
}
