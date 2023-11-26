/*
 *  -   Dartcord is a Discord bot template in Dart for public Use
 *  -   Copyright (c) 2023 Arcane Arts (Volmit Software)
 *  -
 *  -   This program is free software: you can redistribute it and/or modify
 *  -   it under the terms of the GNU General Public License as published by
 *  -   the Free Software Foundation, either version 3 of the License, or
 *  -   (at your option) any later version.
 *  -
 *  -   This program is distributed in the hope that it will be useful,
 *  -   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  -   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  -   GNU General Public License for more details.
 *  -
 *  -   You should have received a copy of the GNU General Public License
 *  -   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:convert';
import 'dart:io';

import 'package:fast_log/fast_log.dart';

class Configurator {
  static Configurator? _instance;

  String discordToken;
  String botImageURL;
  String botColor;
  String botCompanyName;
  String botPrefix;
  double xpBaseMultiplier;
  String botOwnerID;
  String openAiToken;

  // Private constructor
  Configurator._({
    required this.discordToken,
    required this.botImageURL,
    required this.botColor,
    required this.botCompanyName,
    required this.botPrefix,
    required this.xpBaseMultiplier,
    required this.botOwnerID,
    required this.openAiToken,
  });

  // Factory constructor for creating instance from JSON
  factory Configurator.fromJson(Map<String, dynamic> json) {
    _instance ??= Configurator._(
      discordToken: json['discord_token'],
      botImageURL: json['botImageURL'],
      botColor: json['botColor'],
      botCompanyName: json['botCompanyName'],
      botPrefix: json['botPrefix'],
      xpBaseMultiplier: json['xpBaseMultiplier'].toDouble(),
      botOwnerID: json['botOwnerID'],
      openAiToken: json['openAiToken'],
    );
    verbose("Config loaded");
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
  verbose("Loading config");
  var configFile = File('config.json');
  var contents = await configFile.readAsString();
  Map<String, dynamic> configData = json.decode(contents);
  Configurator.fromJson(configData);
}
