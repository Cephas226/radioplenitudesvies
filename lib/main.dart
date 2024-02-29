import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:radioplenitudesvie/pages/dashboard/dashboard_page.dart';
import 'package:radioplenitudesvie/pages/home/page_manager.dart';
import 'audio_helpers/audio_handler.dart';
import 'audio_helpers/service_locator.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

int id = 0;
late AudioHandler audioHandler;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // await setupServiceLocator();
  audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Radio PlenitudeS Vie',
      androidNotificationOngoing: true,
    ),
  );
  checkForUpdate();
  runApp(const MyApp());
}


Future<void> checkForUpdate() async {
  InAppUpdate.checkForUpdate().then((updateInfo) {
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      if (updateInfo.immediateUpdateAllowed) {
        InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
          if (appUpdateResult == AppUpdateResult.success) {
            InAppUpdate.performImmediateUpdate();
          }
        });
      } else if (updateInfo.flexibleUpdateAllowed) {
        InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
          if (appUpdateResult == AppUpdateResult.success) {
            InAppUpdate.completeFlexibleUpdate();
          }
        });
      }
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.SPLASH_SCREEN,
      getPages: AppPages.list,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
    );
  }
}
