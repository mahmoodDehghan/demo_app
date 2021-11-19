import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../screens/profile_screen.dart';
import '../../widgets/containers/home_container.dart';

class HomeScreen extends HookConsumerWidget {
  static const String routeName = '/';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.appName,
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ProfileScreen.routeName);
              },
              icon: const Icon(
                Icons.person,
                color: Colors.amberAccent,
              ))
        ],
      ),
      body: const Center(
        child: HomePageContainer(),
      ),
    );
  }
}
