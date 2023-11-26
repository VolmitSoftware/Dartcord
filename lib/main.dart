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
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/services/ai/openai_manager.dart';

import 'commands/autocrat.dart';
import 'configurator.dart';
import 'listeners/dictator.dart';

late NyxxGateway nyxxBotClient;
late User botUser;

Future<void> initializeConfig() async {
  var configFile = File('config.json');
  var contents = await configFile.readAsString();
  Map<String, dynamic> configData = json.decode(contents);
  Configurator.fromJson(configData);
}

void main() async {
  await initializeConfig();
  verbose("Initializing Config");
  final commands = CommandsPlugin(prefix: mentionOr((_) => '!'));
  autocrat(commands); // Load al
  verbose("Loaded commands");
  var discordToken = Configurator.instance.discordToken;
  nyxxBotClient = await Nyxx.connectGateway(discordToken,
      GatewayIntents.allUnprivileged | GatewayIntents.messageContent,
      options:
          GatewayClientOptions(plugins: [logging, cliIntegration, commands]));
  verbose("Connected to Discord");
  botUser = await nyxxBotClient.users.fetchCurrentUser();
  verbose("Fetched bot user");
  registerListeners(nyxxBotClient, commands); // Load all Listeners
  verbose("Loaded listeners");
  OpenAIManager.instance.initialize(Configurator.instance.openAiToken);
  verbose("Initialized OpenAI");
}
