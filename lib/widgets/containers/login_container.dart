import '../../providers/user_loginned_state_provider.dart';

import '../../providers/shared_prefrences_provider.dart';
import '../../widgets/forms/login_form.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginContainer extends HookConsumerWidget {
  const LoginContainer({
    Key? key,
  }) : super(key: key);

  Widget loginWithErrorLayout(
    BuildContext context,
    String error, {
    required ValueNotifier loginEntry,
    required ValueNotifier remember,
  }) {
    return ListView(
      children: [
        LoginForm(
          loginEntry: loginEntry,
          remember: remember,
        ),
        const SizedBox(
          height: 15,
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              error,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget getProgressBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getProperWidget(
      BuildContext context, WidgetRef ref, UserLoginState state,
      {required ValueNotifier remember, required ValueNotifier loginEntry}) {
    if (state.isNotLogined) {
      return LoginForm(
        loginEntry: loginEntry,
        remember: remember,
      );
    } else if (state.isLoginFailed) {
      return loginWithErrorLayout(context, state.error,
          remember: remember, loginEntry: loginEntry);
    } else {
      return getProgressBar();
    }
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
            ref.refresh(sharedPrefrencesProvider);
          },
          icon: Icon(
            Icons.refresh,
            color: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remember = useState(true);
    final userState = ref.watch(userProvider);
    final loginEntry = useState<Map<String, String>>({});
    return getProperWidget(context, ref, userState,
        remember: remember, loginEntry: loginEntry);
  }
}
