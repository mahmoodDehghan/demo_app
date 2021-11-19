import '../../models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserDetailsContainer extends HookConsumerWidget {
  const UserDetailsContainer({Key? key, required this.profile})
      : super(key: key);
  final UserProfile profile;

  Widget getStringItemRow(BuildContext context, String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title + " : "),
        const SizedBox(
          width: 20,
        ),
        Text(value),
      ],
    );
  }

  Widget getDivider(BuildContext context) {
    return Divider(
      color: Theme.of(context).primaryColor,
      height: 10,
      thickness: 3,
      indent: 5,
      endIndent: 5,
    );
  }

  Widget getGenderView(BuildContext context, int gender) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.genderTitle + ": "),
        gender == 0
            ? Text(AppLocalizations.of(context)!.male)
            : Text(AppLocalizations.of(context)!.female)
      ],
    );
  }

  Widget notConfirmedWidget(String warning) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        color: Colors.pinkAccent,
        child: Center(
          child: Text(warning),
        ),
      ),
    );
  }

  Widget getConfirmationWarnings(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!profile.confirmEmail)
          notConfirmedWidget(
              AppLocalizations.of(context)!.emailNotConfirmedError),
        if (!profile.confirmMobile)
          notConfirmedWidget(
              AppLocalizations.of(context)!.mobileNotConfirmedError),
        if (!profile.confirmPhone)
          notConfirmedWidget(
              AppLocalizations.of(context)!.phoneNotConfirmedError),
      ],
    );
  }

  Widget getHeaderWidget(BuildContext context, String header) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Divider(
              color: Colors.indigo,
              height: 25,
              thickness: 3,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              header,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Divider(
              color: Colors.indigo,
              height: 25,
              thickness: 3,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ListView(
        children: [
          getHeaderWidget(
              context, AppLocalizations.of(context)!.personalInfoTitle),
          getStringItemRow(
              context, AppLocalizations.of(context)!.emailTitle, profile.email),
          getDivider(context),
          getStringItemRow(
              context, AppLocalizations.of(context)!.nameTitle, profile.name),
          getDivider(context),
          getStringItemRow(context, AppLocalizations.of(context)!.familyTitle,
              profile.family),
          getDivider(context),
          getStringItemRow(context,
              AppLocalizations.of(context)!.birthDateTitle, profile.birthDate),
          getDivider(context),
          getGenderView(context, profile.gender),
          getHeaderWidget(
              context, AppLocalizations.of(context)!.contactHeaderTitle),
          getStringItemRow(
              context,
              AppLocalizations.of(context)!.countryNameTitle,
              profile.countryName),
          getDivider(context),
          getStringItemRow(
              context,
              AppLocalizations.of(context)!.postalCodeTitle,
              profile.postalCode),
          getDivider(context),
          getStringItemRow(context, AppLocalizations.of(context)!.addressTitle,
              profile.address),
          getDivider(context),
          getStringItemRow(
              context,
              AppLocalizations.of(context)!.nationalCodeTitle,
              profile.nationalCode),
          getDivider(context),
          getStringItemRow(
              context, AppLocalizations.of(context)!.phoneTitle, profile.phone),
          getDivider(context),
          getStringItemRow(context, AppLocalizations.of(context)!.mobileTitle,
              profile.phoneNumber),
          getDivider(context),
          getConfirmationWarnings(context),
        ],
      ),
    );
  }
}
