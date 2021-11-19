import 'package:demo_app/providers/user_loginned_state_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/get_profile_provider.dart';
import '../../providers/shared_prefrences_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePageContainer extends HookConsumerWidget {
  const ProfilePageContainer({
    Key? key,
  }) : super(key: key);

  Widget getProgressBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getErrorWidget(BuildContext context, WidgetRef ref, String error) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              error,
              style: Theme.of(context).textTheme.headline4,
            )),
        const SizedBox(
          height: 30,
        ),
        IconButton(
          onPressed: () {
            ref.refresh(getProfileProvider(context));
          },
          icon: Icon(
            Icons.refresh,
            color: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }

  Widget getProperWidget(
      BuildContext context, WidgetRef ref, UserLoginState state) {
    if (state.isGettingProfileFailed) {
      return getErrorWidget(context, ref, state.error);
    } else {
      return getProgressBar();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    return getProperWidget(context, ref, userState);
  }
}
