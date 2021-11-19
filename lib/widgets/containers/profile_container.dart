import '../../helpers/internet_helper.dart';

import '../../helpers/const_items.dart';
import '../../providers/get_profile_provider.dart';
import '../../providers/shared_prefrences_provider.dart';
import '../../widgets/containers/login_container.dart';
import '../../widgets/containers/user_details_container.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePageContainer extends HookConsumerWidget {
  const ProfilePageContainer({Key? key, required this.logOutState})
      : super(key: key);
  final ValueNotifier logOutState;

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
    // return Center(
    //   child: Text(
    //     error,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (logOutState.value) {
      return const LoginContainer();
    }
    final prefProvider = ref.watch(sharedPrefrencesProvider);
    return prefProvider.when(
      data: (pref) {
        if (pref.getString(ConstItems.userToken) == null) {
          return const LoginContainer();
        } else {
          final profile = ref.watch(getProfileProvider(context));
          return profile.when(
            data: (profile) {
              return UserDetailsContainer(
                profile: profile,
              );
            },
            error: (error, stack) {
              if (InternetHelper.isNoInternetError(error.toString())) {
                return getErrorWidget(context, ref,
                    AppLocalizations.of(context)!.noInternetError);
              }
              return getErrorWidget(context, ref, error.toString());
            },
            loading: getProgressBar,
          );
        }
      },
      error: (error, stack) {
        return getErrorWidget(
            context, ref, AppLocalizations.of(context)!.generalError);
      },
      loading: getProgressBar,
    );
  }
}
