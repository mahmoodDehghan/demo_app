import '../helpers/const_items.dart';
import '../providers/shared_prefrences_provider.dart';
import '../widgets/containers/profile_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends HookConsumerWidget {
  static const String routeName = 'profileScreen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logoutCalled = useState(false);
    final showLogout = useState(false);
    final pref = ref.watch(sharedPrefrencesProvider);
    pref.whenData((pref) {
      showLogout.value = pref.getString(ConstItems.userToken) != null;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profileScreenTitle,
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          if (showLogout.value)
            IconButton(
                onPressed: () async {
                  final pref = await ref.read(sharedPrefrencesProvider.future);
                  pref.remove(ConstItems.userToken);
                  logoutCalled.value = true;
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.amberAccent,
                ))
        ],
      ),
      body: Center(
        child: ProfilePageContainer(logOutState: logoutCalled),
      ),
    );
  }
}
