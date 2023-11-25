import 'dart:convert';
import 'dart:io';

class Configurator {
  static Configurator? _instance;

  String discordToken;
  String botImageURL;
  String botColor;
  String adminControllerRoleId;
  String botCompanyName;
  String botPrefix;
  double xpBaseMultiplier;
  String botOwnerID;
  String catApiToken;

  // Private constructor
  Configurator._({
    required this.discordToken,
    required this.botImageURL,
    required this.botColor,
    required this.adminControllerRoleId,
    required this.botCompanyName,
    required this.botPrefix,
    required this.xpBaseMultiplier,
    required this.botOwnerID,
    required this.catApiToken,
  });

  // Factory constructor for creating instance from JSON
  factory Configurator.fromJson(Map<String, dynamic> json) {
    _instance ??= Configurator._(
      discordToken: json['discord_token'],
      botImageURL: json['botImageURL'],
      botColor: json['botColor'],
      adminControllerRoleId: json['adminControllerRoleId'],
      botCompanyName: json['botCompanyName'],
      botPrefix: json['botPrefix'],
      xpBaseMultiplier: json['xpBaseMultiplier'].toDouble(),
      botOwnerID: json['botOwnerID'],
      catApiToken: json['catApiToken'],
    );
    return _instance!;
  }

  // Static getter to access the instance
  static Configurator get instance {
    if (_instance == null) {
      throw Exception('Config has not been initialized.');
    }
    return _instance!;
  }
}

// Function to load and initialize the configuration
Future<void> initializeConfig() async {
  var configFile = File('config.json');
  var contents = await configFile.readAsString();
  Map<String, dynamic> configData = json.decode(contents);
  Configurator.fromJson(configData);
}