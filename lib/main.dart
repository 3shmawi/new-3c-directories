import 'package:flutter/material.dart';
// import 'iframe_util.dart';
import 'package:flutter/services.dart';
import 'package:new_3c/providers/queue_provider.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'utils/app_localizations.dart';
import 'utils/theme.dart';

void main() {
  // dfInitMessageListener();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ChangeNotifierProvider(
      create: (context) => QueueProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Barber',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: Locale("ar"),
      supportedLocales: const [
        Locale('ar'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
      ],
      // localeResolutionCallback: (locale, supportedLocales) {
      //   for (var supportedLocale in supportedLocales) {
      //     if (supportedLocale.languageCode == locale?.languageCode) {
      //       return supportedLocale;
      //     }
      //   }
      //   return supportedLocales.first;
      // },
      home: const HomeScreen(),
    );
  }
}
