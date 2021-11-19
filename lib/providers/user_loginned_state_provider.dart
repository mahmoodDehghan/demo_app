import 'dart:convert';

import 'package:demo_app/providers/shared_prefrences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/const_items.dart';

import '../../models/token_response.dart';
import '../../models/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum UserLoginStatus {
  loging,
  logined,
  notlogined,
  loginFailed,
  gettingProfileFailed,
  loginedWithoutProfile,
  gettingProfile,
}

class UserLoginState {
  final UserLoginStatus _status;
  final UserProfile? _profile;
  final String _error;
  final StateNotifierProviderRef ref;

  String get error {
    return _error;
  }

  bool get isLogined {
    return _status == UserLoginStatus.logined;
  }

  bool get needToGetProfile {
    return _status == UserLoginStatus.loginedWithoutProfile;
  }

  bool get isInLogin {
    return _status == UserLoginStatus.loging;
  }

  bool get isInGettingProfile {
    return _status == UserLoginStatus.gettingProfile;
  }

  bool get isNotLogined {
    return _status == UserLoginStatus.notlogined;
  }

  bool get isLoginFailed {
    return _status == UserLoginStatus.loginFailed;
  }

  bool get isGettingProfileFailed {
    return _status == UserLoginStatus.gettingProfileFailed;
  }

  UserProfile? get profile {
    return _profile;
  }

  UserLoginState(this._profile, this._status, this.ref, [this._error = '']);
}

final userProvider =
    StateNotifierProvider<UserLoginStateNotifier, UserLoginState>((ref) {
  return UserLoginStateNotifier(
    UserLoginState(null, UserLoginStatus.notlogined, ref),
  );
});

class UserLoginStateNotifier extends StateNotifier<UserLoginState> {
  UserLoginStateNotifier(UserLoginState state) : super(state);

  set profile(UserProfile profile) {
    state = UserLoginState(profile, UserLoginStatus.logined, state.ref);
  }

  set error(String error) {
    state = UserLoginState(null, UserLoginStatus.loginFailed, state.ref, error);
  }

  set profileError(String error) {
    state = UserLoginState(
        null, UserLoginStatus.gettingProfileFailed, state.ref, error);
  }

  void setInLoading() {
    state = UserLoginState(null, UserLoginStatus.loging, state.ref);
  }

  void setInGettingProfile() {
    state = UserLoginState(null, UserLoginStatus.gettingProfile, state.ref);
  }

  Future<void> checkLoginStatus(BuildContext context) async {
    if (!state.isLogined) {
      final pref = await state.ref.read(sharedPrefrencesProvider.future);
      final token = pref.getString(ConstItems.userToken);
      if (token != null) {
        getUserProfileOnly(context, token);
      }
    }
  }

  Future<void> logout() async {
    final pref = await state.ref.read(sharedPrefrencesProvider.future);
    pref.remove(ConstItems.userToken);
    pref.remove(ConstItems.userRefreshToken);
    state = UserLoginState(null, UserLoginStatus.notlogined, state.ref);
  }

  Future<void> getUserProfileOnly(BuildContext context, String token) async {
    setInGettingProfile();
    final response = await http.get(
        Uri.parse(ConstItems.baseUrl + ConstItems.getProfileUrl),
        headers: {'Authorization': 'Bearer ' + token});
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body) as Map<String, dynamic>;
      if (result['error']) {
        profileError = result['message'];
      } else {
        profile = UserProfile.fromJson(result['result']);
      }
    } else {
      profileError = AppLocalizations.of(context)!.getProfileError;
    }
  }

  Future<void> login(BuildContext context, Map<String, String> loginEntry,
      bool saveTokens) async {
    setInLoading();
    final token = await getToken(context, loginEntry);
    if (token.hasError) {
      error = token.errorMessage!.first;
    } else {
      if (saveTokens) {
        final pref = await state.ref.read(sharedPrefrencesProvider.future);
        pref.setString(ConstItems.userToken, token.token!);
        pref.setString(ConstItems.userRefreshToken, token.refreshToken!);
      }
      await getUserProfile(context, token);
    }
  }

  Future<void> getUserProfile(
    BuildContext context,
    TokenResponse token,
  ) async {
    final response = await http.get(
        Uri.parse(ConstItems.baseUrl + ConstItems.getProfileUrl),
        headers: {'Authorization': 'Bearer ' + token.token!});
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body) as Map<String, dynamic>;
      if (result['error']) {
        error = result['message'];
      } else {
        profile = UserProfile.fromJson(result['result']);
      }
    } else {
      error = AppLocalizations.of(context)!.getProfileError;
    }
  }

  Future<TokenResponse> getToken(
    BuildContext context,
    Map<String, String> loginEntry,
  ) async {
    final response = await http.post(
        Uri.parse(ConstItems.baseUrl + ConstItems.loginUrl),
        headers: {'content-type': 'application/json'},
        body: jsonEncode(loginEntry));
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
}
