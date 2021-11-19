import 'dart:ui';

import './screens/home_screen.dart';
import './screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainApp extends HookConsumerWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appName,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fa', ''),
      ],
      locale: const Locale('fa', ''),
      theme: ThemeData(
          primarySwatch: Colors.blue,
          errorColor: Colors.redAccent,
          textTheme: const TextTheme(
            bodyText1: TextStyle(fontFamily: 'IranSans'),
            button: TextStyle(fontFamily: 'IranSans'),
            subtitle1: TextStyle(fontFamily: 'IranSans'),
            bodyText2: TextStyle(fontFamily: 'IranSans', fontSize: 14),
            headline1: TextStyle(
                fontFamily: 'IranSans',
                fontWeight: FontWeight.bold,
                fontSize: 20),
            headline4: TextStyle(
              fontFamily: 'IranSans',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.redAccent,
            ),
            headline2: TextStyle(
                fontFamily: 'IranSans',
                color: Colors.indigo,
                fontWeight: FontWeight.w700,
                fontSize: 16),
          )),
      routes: {
        HomeScreen.routeName: (ctx) => const HomeScreen(),
        ProfileScreen.routeName: (ctx) => const ProfileScreen(),
      },
      initialRoute: HomeScreen.routeName,
    );
  }
}
