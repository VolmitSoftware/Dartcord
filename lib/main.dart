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
