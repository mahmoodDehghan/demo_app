import 'package:demo_app/widgets/containers/login_container.dart';
import 'package:demo_app/widgets/containers/user_details_container.dart';

import '../providers/user_loginned_state_provider.dart';
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

  Widget getPrefError(BuildContext context, String error) {
    return Scaffold(
      body: Center(
        child: Text(
          error,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }

  Widget getPrefLoading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget getProperContainer(UserLoginState state) {
    if (state.isLogined) {
      return UserDetailsContainer(profile: state.profile!);
    } else if (state.isInGettingProfile || state.isGettingProfileFailed) {
      return const ProfilePageContainer();
    } else {
      return const LoginContainer();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(userProvider.notifier).checkLoginStatus(context);
    final userState = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profileScreenTitle,
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          if (userState.isLogined || userState.needToGetProfile)
            IconButton(
                onPressed: () {
                  ref.read(userProvider.notifier).logout();
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.amberAccent,
                ))
        ],
      ),
      body: Center(
        child: getProperContainer(userState),
      ),
    );
  }
}
