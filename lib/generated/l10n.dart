// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `SmartPark`
  String get appTitle {
    return Intl.message(
      'SmartPark',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Invalid username or password`
  String get invalidCredentials {
    return Intl.message(
      'Invalid username or password',
      name: 'invalidCredentials',
      desc: '',
      args: [],
    );
  }

  /// `Plate not registered`
  String get plateNotRegistered {
    return Intl.message(
      'Plate not registered',
      name: 'plateNotRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Network error: {error}`
  String networkError(Object error) {
    return Intl.message(
      'Network error: $error',
      name: 'networkError',
      desc: '',
      args: [error],
    );
  }

  /// `Database downloaded successfully`
  String get databaseDownloaded {
    return Intl.message(
      'Database downloaded successfully',
      name: 'databaseDownloaded',
      desc: '',
      args: [],
    );
  }

  /// `Failed to download database`
  String get databaseDownloadFailed {
    return Intl.message(
      'Failed to download database',
      name: 'databaseDownloadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Configuration saved`
  String get configurationSaved {
    return Intl.message(
      'Configuration saved',
      name: 'configurationSaved',
      desc: '',
      args: [],
    );
  }

  /// `Configuration reset to default`
  String get configurationReset {
    return Intl.message(
      'Configuration reset to default',
      name: 'configurationReset',
      desc: '',
      args: [],
    );
  }

  /// `Local database deleted`
  String get localDatabaseDeleted {
    return Intl.message(
      'Local database deleted',
      name: 'localDatabaseDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Plate entry deleted`
  String get plateEntryDeleted {
    return Intl.message(
      'Plate entry deleted',
      name: 'plateEntryDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Failed to initialize the camera`
  String get cameraInitializationFailed {
    return Intl.message(
      'Failed to initialize the camera',
      name: 'cameraInitializationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Camera permission denied`
  String get cameraPermissionDenied {
    return Intl.message(
      'Camera permission denied',
      name: 'cameraPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Plate saved`
  String get plateSaved {
    return Intl.message(
      'Plate saved',
      name: 'plateSaved',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Reset to Default`
  String get resetToDefault {
    return Intl.message(
      'Reset to Default',
      name: 'resetToDefault',
      desc: '',
      args: [],
    );
  }

  /// `Delete Local Database`
  String get deleteLocalDatabase {
    return Intl.message(
      'Delete Local Database',
      name: 'deleteLocalDatabase',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Spanish`
  String get spanish {
    return Intl.message(
      'Spanish',
      name: 'spanish',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
