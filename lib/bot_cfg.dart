import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:fast_log/fast_log.dart';

class BotCFG {
  static final BotCFG _i = BotCFG._internal();

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
  BotCFG._internal({
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
  factory BotCFG.fromJson(Map<String, dynamic> json) {
    _i.discordToken = json['discord_token'] as String? ?? _i.discordToken;
    _i.botImageURL = json['botImageURL'] as String? ?? _i.botImageURL;
    _i.botColor = json['botColor'] as String? ?? _i.botColor;
    _i.botCompanyName = json['botCompanyName'] as String? ?? _i.botCompanyName;
    _i.botPrefix = json['botPrefix'] as String? ?? _i.botPrefix;
    _i.xpBaseMultiplier =
        (json['xpBaseMultiplier'] as num?)?.toDouble() ?? _i.xpBaseMultiplier;
    _i.botOwnerID = json['botOwnerID'] as String? ?? _i.botOwnerID;
    _i.openAiToken = json['openAiToken'] as String? ?? _i.openAiToken;

    // xpPerMessage checks
    if (json.containsKey('xpPerMessage') &&
        json['xpPerMessage'] is Map<String, dynamic>) {
      var xpPerMessage = json['xpPerMessage'] as Map<String, dynamic>;
      _i.xpMin = (xpPerMessage['min'] as num?)?.toDouble() ?? _i.xpMin;
      _i.xpMax = (xpPerMessage['max'] as num?)?.toDouble() ?? _i.xpMax;
    }

    verbose("Config loaded");
    return _i;
  }

  // Static getter to access the instance
  static BotCFG get i {
    return _i;
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
    BotCFG.fromJson(configData);
  } catch (e) {
    verbose("Error loading config: $e");
    // Handle the error appropriately
  }
}
