import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:fast_log/fast_log.dart';

class Configurator {
  static final Configurator _instance = Configurator._internal();

  String discordToken;
  String botImageURL;
  String botColor;
  String botCompanyName;
  String botPrefix;
  double xpBaseMultiplier;
  String botOwnerID;
  String openAiToken;
  double xpMin;
  double xpMax;

  // Private constructor for internal use
  Configurator._internal({
    this.discordToken = 'none',
    this.botImageURL = 'none',
    this.botColor = 'none',
    this.botCompanyName = 'none',
    this.botPrefix = 'none',
    this.xpBaseMultiplier = 1.0,
    this.botOwnerID = 'none',
    this.openAiToken = 'none',
    this.xpMin = 0.0,
    this.xpMax = 3.0,
  });

  // Factory constructor for creating instance from JSON
  factory Configurator.fromJson(Map<String, dynamic> json) {
    _instance.discordToken =
        json['discord_token'] as String? ?? _instance.discordToken;
    _instance.botImageURL =
        json['botImageURL'] as String? ?? _instance.botImageURL;
    _instance.botColor = json['botColor'] as String? ?? _instance.botColor;
    _instance.botCompanyName =
        json['botCompanyName'] as String? ?? _instance.botCompanyName;
    _instance.botPrefix = json['botPrefix'] as String? ?? _instance.botPrefix;
    _instance.xpBaseMultiplier =
        (json['xpBaseMultiplier'] as num?)?.toDouble() ??
            _instance.xpBaseMultiplier;
    _instance.botOwnerID =
        json['botOwnerID'] as String? ?? _instance.botOwnerID;
    _instance.openAiToken =
        json['openAiToken'] as String? ?? _instance.openAiToken;

    // xpPerMessage checks
    if (json.containsKey('xpPerMessage') &&
        json['xpPerMessage'] is Map<String, dynamic>) {
      var xpPerMessage = json['xpPerMessage'] as Map<String, dynamic>;
      _instance.xpMin =
          (xpPerMessage['min'] as num?)?.toDouble() ?? _instance.xpMin;
      _instance.xpMax =
          (xpPerMessage['max'] as num?)?.toDouble() ?? _instance.xpMax;
    }

    verbose("Config loaded");
    return _instance;
  }

  // Static getter to access the instance
  static Configurator get instance {
    return _instance;
  }

  // Method to get a random XP value
  double getRandomXP() {
    return xpMin + math.Random().nextDouble() * (xpMax - xpMin);
  }
}

// Function to load and initialize the configuration
Future<void> initializeConfig() async {
  verbose("Loading config");
  try {
    var configFile = File('config.json');
    var contents = await configFile.readAsString();
    Map<String, dynamic> configData = json.decode(contents);
    Configurator.fromJson(configData);
  } catch (e) {
    verbose("Error loading config: $e");
    // Handle the error appropriately
  }
}
