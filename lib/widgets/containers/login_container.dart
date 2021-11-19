import 'dart:convert';

import 'package:demo_app/helpers/internet_helper.dart';

import '../../helpers/const_items.dart';
import '../../models/token_response.dart';
import '../../providers/shared_prefrences_provider.dart';
import '../../widgets/containers/user_details_container.dart';
import '../../widgets/forms/login_form.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../hooks/http_client_hook.dart';
import '../../models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

class LoginContainer extends HookConsumerWidget {
  const LoginContainer({Key? key}) : super(key: key);
  // late ValueNotifier loginEntry;
  // late ValueNotifier remember;

  Future<UserProfile> getUserProfile(
      BuildContext context, http.Client client, TokenResponse token) async {
    final response = await client.get(
        Uri.parse(ConstItems.baseUrl + ConstItems.getProfileUrl),
        headers: {'Authorization': 'Bearer ' + token.token!});
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body) as Map<String, dynamic>;
      if (result['error']) {
        throw Exception(result['message']);
      } else {
        return UserProfile.fromJson(result['result']);
      }
    } else {
      throw Exception(AppLocalizations.of(context)!.getProfileError);
    }
  }

  Future<TokenResponse> login(BuildContext context, http.Client client,
      {required ValueNotifier loginEntry}) async {
    final response = await client.post(
        Uri.parse(ConstItems.baseUrl + ConstItems.loginUrl),
        headers: {'content-type': 'application/json'},
        body: jsonEncode(loginEntry.value));
    if (response.statusCode == 200 || response.statusCode == 400) {
      return TokenResponse.fromJson(jsonDecode(response.body));
    } else {
      return TokenResponse(
        token: null,
        refreshToken: null,
        hasError: true,
        errorMessage: [AppLocalizations.of(context)!.generalError],
      );
    }
  }

  Future<void> saveToken(WidgetRef ref, TokenResponse tokenResponse) async {
    final pref = await ref.read(sharedPrefrencesProvider.future);
    pref.setString(ConstItems.userToken, tokenResponse.token!);
  }

  Future<UserProfile?> loginAndGetProfile(
      BuildContext context, http.Client client, WidgetRef ref,
      {required ValueNotifier loginEntry,
      required ValueNotifier remember}) async {
    final TokenResponse token = await login(
      context,
      client,
      loginEntry: loginEntry,
    );
    if (token.token != null) {
      if (remember.value) {
        saveToken(ref, token);
      }
      return await getUserProfile(context, client, token);
    } else {
      throw (token.errorMessage!.first);
    }
  }

  Widget loginWithErrorLayout(BuildContext context, String error,
      {required ValueNotifier loginEntry, required ValueNotifier remember}) {
    return ListView(
      children: [
        LoginForm(loginEntry: loginEntry, remember: remember),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remember = useState(true);
    final client = useHttpClientHook(context);
    final loginEntry = useState<Map<String, String>>({});
    final entryDict = loginEntry.value;
    return entryDict.keys.isNotEmpty
        ? FutureBuilder(
            future: loginAndGetProfile(context, client, ref,
                loginEntry: loginEntry, remember: remember),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  if (InternetHelper.isNoInternetError(
                      snapshot.error.toString())) {
                    return loginWithErrorLayout(
                        context, AppLocalizations.of(context)!.noInternetError,
                        loginEntry: loginEntry, remember: remember);
                  }
                  return loginWithErrorLayout(
                      context, snapshot.error.toString(),
                      loginEntry: loginEntry, remember: remember);
                }
                if (snapshot.hasData) {
                  return UserDetailsContainer(
                      profile: snapshot.data as UserProfile);
                }
                return loginWithErrorLayout(
                    context, AppLocalizations.of(context)!.noDataError,
                    loginEntry: loginEntry, remember: remember);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        : Center(
            child: LoginForm(loginEntry: loginEntry, remember: remember),
          );
  }
}
