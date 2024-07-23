import 'package:android_intent/android_intent.dart';

Future<void> promptSetDefaultLauncher() async {
  const intent = AndroidIntent(
    action: 'android.settings.HOME_SETTINGS',
  );
  await intent.launch();
}
