// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(error) => "Network error: ${error}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appTitle": MessageLookupByLibrary.simpleMessage("SmartPark"),
        "cameraInitializationFailed": MessageLookupByLibrary.simpleMessage(
            "Failed to initialize the camera"),
        "cameraPermissionDenied":
            MessageLookupByLibrary.simpleMessage("Camera permission denied"),
        "configurationReset": MessageLookupByLibrary.simpleMessage(
            "Configuration reset to default"),
        "configurationSaved":
            MessageLookupByLibrary.simpleMessage("Configuration saved"),
        "databaseDownloadFailed":
            MessageLookupByLibrary.simpleMessage("Failed to download database"),
        "databaseDownloaded": MessageLookupByLibrary.simpleMessage(
            "Database downloaded successfully"),
        "deleteLocalDatabase":
            MessageLookupByLibrary.simpleMessage("Delete Local Database"),
        "english": MessageLookupByLibrary.simpleMessage("English"),
        "invalidCredentials": MessageLookupByLibrary.simpleMessage(
            "Invalid username or password"),
        "localDatabaseDeleted":
            MessageLookupByLibrary.simpleMessage("Local database deleted"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "networkError": m0,
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "plateEntryDeleted":
            MessageLookupByLibrary.simpleMessage("Plate entry deleted"),
        "plateNotRegistered":
            MessageLookupByLibrary.simpleMessage("Plate not registered"),
        "plateSaved": MessageLookupByLibrary.simpleMessage("Plate saved"),
        "resetToDefault":
            MessageLookupByLibrary.simpleMessage("Reset to Default"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "spanish": MessageLookupByLibrary.simpleMessage("Spanish"),
        "username": MessageLookupByLibrary.simpleMessage("Username")
      };
}
