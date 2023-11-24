import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/commands/slash/embed/embed.dart';
import 'package:running_on_dart/commands/slash/ping/command_ping.dart';
import 'package:running_on_dart/commands/slash/ping/command_ping3.dart';
import 'package:running_on_dart/commands/slash/ping/command_ping4.dart';

void autocrat(CommandsPlugin commands) {
  commands..addCommand(pingSelection);
  commands..addCommand(pingString);
  commands..addCommand(pingChoices);
  commands..addCommand(embed);

  // Add more commands here
  ;
}
