import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';

import 'dart:math' as math;

import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../data/data_source/local_data_source.dart';
import '../resources/assets_manager.dart';
import '../resources/language_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AppPreferences _appPreferences = instance<AppPreferences>();
  LocalDataSource _localDataSource = instance<LocalDataSource>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppPadding.p8),
      children: [
        ListTile(
          title: Text(
            AppStrings.changeLanguage,
            style: Theme.of(context).textTheme.headlineLarge,
          ).tr(),
          leading: SvgPicture.asset(ImageAssets.changeLangIc),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          ),
          onTap: () {
            _changeLanguage();
          },
        ),
        ListTile(
          title: Text(
            AppStrings.contactUs,
            style: Theme.of(context).textTheme.headlineLarge,
          ).tr(),
          leading: SvgPicture.asset(ImageAssets.contactUsIc),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          ),
          onTap: () {
            _contactUs();
          },
        ),
        ListTile(
          title: Text(
            AppStrings.inviteYourFriends,
            style: Theme.of(context).textTheme.headlineLarge,
          ).tr(),
          leading: SvgPicture.asset(ImageAssets.inviteFriendsIc),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          ),
          onTap: () {
            _inviteFriends();
          },
        ),
        ListTile(
          title: Text(
            AppStrings.logout,
            style: Theme.of(context).textTheme.headlineLarge,
          ).tr(),
          leading: SvgPicture.asset(ImageAssets.logoutIc),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
            child: SvgPicture.asset(ImageAssets.settingsRightArrowIc),
          ),
          onTap: () {
            _logout();
          },
        )
      ],
    );
  }

  bool isRtl() {
    return context.locale == ARABIC_LOCAL; // app is in arabic language
  }

  void _changeLanguage() {
    // i will apply localisation later
    _appPreferences.setLanguageChanged();
    Phoenix.rebirth(context); // restart to apply language changes
  }

  void _contactUs() {
    // its a task for you to open any web bage with dummy content
  }

  void _inviteFriends() {
    // its a task to share app name with friends
  }

  void _logout() {
    _appPreferences.logout(); // clear login flag from app prefs
    _localDataSource.clearCache();
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.loginRoute, (route) => false,);
  }
}
