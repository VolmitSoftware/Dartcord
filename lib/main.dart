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

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import 'commands/autocrat.dart';
import 'listeners/dictator.dart';

Future<Map<String, dynamic>> loadConfig() async {
  var configFile = File('config.json');
  var contents = await configFile.readAsString();
  return json.decode(contents);
}

void main() async {
  final commands = CommandsPlugin(prefix: mentionOr((_) => '!'));
  autocrat(commands); // Load all commands

  var config = await loadConfig();
  var discordToken = config['discord_token'];
  final client = await Nyxx.connectGateway(discordToken, GatewayIntents.allUnprivileged | GatewayIntents.messageContent, options: GatewayClientOptions(plugins: [logging, cliIntegration, commands]));
  final botUser = await client.users.fetchCurrentUser();
  registerListeners(client, commands); // Register all listeners
}
