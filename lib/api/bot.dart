/*
 * This is a project by ArcaneArts, for free/public use!
 * Copyright (c) 2023 Arcane Arts (Volmit Software)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:convert';
import 'dart:io';

import 'package:fast_log/fast_log.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/bot_cfg.dart';

typedef CommandInitializer = CommandsPlugin Function();
typedef ListenerRegistrar = void Function(NyxxGateway, CommandsPlugin);

class DartcordBot {
  late final NyxxGateway client;
  late final User botUser;
  final String token;
  final Flags<GatewayIntents>? intents;
  final String? prefix;
  final CommandInitializer commandInitializer;
  final ListenerRegistrar listenerRegistrar;

  DartcordBot({
    required this.token,
    this.intents,
    this.prefix,
    required this.commandInitializer,
    required this.listenerRegistrar,
  });

  Future<void> initializeConfig() async {
    var configFile = File('config.json');
    var contents = await configFile.readAsString();
    Map<String, dynamic> configData = json.decode(contents);
    BotCFG.fromJson(configData);
  }

  CommandsPlugin initializeCommands() {
    // Use the provided commandInitializer callback to initialize commands
    return commandInitializer();
  }

  Future<void> connect() async {
    await initializeConfig();
    verbose("Initializing Config");

    final commandsPlugin = initializeCommands();
    client = await Nyxx.connectGateway(
        token,
        intents ??
            GatewayIntents.allUnprivileged | GatewayIntents.messageContent,
        options: GatewayClientOptions(
            plugins: [logging, cliIntegration, commandsPlugin]));

    botUser = await client.users.fetchCurrentUser();

    // Use the provided listenerRegistrar callback to register listeners
    listenerRegistrar(client, commandsPlugin);
  }
}
