// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static String m0(error) => "Error de red: ${error}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appTitle": MessageLookupByLibrary.simpleMessage("SmartPark"),
        "cameraInitializationFailed": MessageLookupByLibrary.simpleMessage(
            "Error al inicializar la cámara"),
        "cameraPermissionDenied":
            MessageLookupByLibrary.simpleMessage("Permiso de cámara denegado"),
        "configurationReset": MessageLookupByLibrary.simpleMessage(
            "Configuración restablecida a los valores predeterminados"),
        "configurationSaved":
            MessageLookupByLibrary.simpleMessage("Configuración guardada"),
        "databaseDownloadFailed": MessageLookupByLibrary.simpleMessage(
            "Error al descargar la base de datos"),
        "databaseDownloaded": MessageLookupByLibrary.simpleMessage(
            "Base de datos descargada con éxito"),
        "deleteLocalDatabase": MessageLookupByLibrary.simpleMessage(
            "Eliminar base de datos local"),
        "english": MessageLookupByLibrary.simpleMessage("Inglés"),
        "invalidCredentials": MessageLookupByLibrary.simpleMessage(
            "Nombre de usuario o contraseña inválidos"),
        "localDatabaseDeleted": MessageLookupByLibrary.simpleMessage(
            "Base de datos local eliminada"),
        "login": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
        "networkError": m0,
        "password": MessageLookupByLibrary.simpleMessage("Contraseña"),
        "plateEntryDeleted":
            MessageLookupByLibrary.simpleMessage("Entrada de placa eliminada"),
        "plateNotRegistered":
            MessageLookupByLibrary.simpleMessage("Placa no registrada"),
        "plateSaved": MessageLookupByLibrary.simpleMessage("Placa guardada"),
        "resetToDefault": MessageLookupByLibrary.simpleMessage(
            "Restablecer a los valores predeterminados"),
        "save": MessageLookupByLibrary.simpleMessage("Guardar"),
        "spanish": MessageLookupByLibrary.simpleMessage("Español"),
        "username": MessageLookupByLibrary.simpleMessage("Nombre de usuario")
      };
}
