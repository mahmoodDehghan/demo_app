import 'dart:convert';

import '../../helpers/const_items.dart';
import '../../models/user_profile.dart';
import '../../providers/shared_prefrences_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final getProfileProvider =
    FutureProvider.family<UserProfile, BuildContext>((ref, context) async {
  final pref = await ref.read(sharedPrefrencesProvider.future);
  final token = pref.getString(ConstItems.userToken);
  final response = await http.get(
      Uri.parse(ConstItems.baseUrl + ConstItems.getProfileUrl),
      headers: {'Authorization': 'Bearer ' + token!});
  if (response.statusCode == 200) {
    final result = jsonDecode(response.body) as Map<String, dynamic>;
    if (result['error']) {
      throw (result['message']);
    } else {
      return UserProfile.fromJson(result['result']);
    }
  } else if (response.statusCode == 401) {
    throw (AppLocalizations.of(context)!.reloginPlease);
  } else {
    throw (AppLocalizations.of(context)!.getProfileError);
  }
});
