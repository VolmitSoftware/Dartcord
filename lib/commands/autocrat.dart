import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/commands/slash/command_ping.dart';

void autocrat(CommandsPlugin commands) {
  commands..addCommand(ping)
      // ..addCommand(ping2)
      // ..addCommand(ping3)
      // ..addCommand(ping4)
      // Add more commands here
      ;
}
