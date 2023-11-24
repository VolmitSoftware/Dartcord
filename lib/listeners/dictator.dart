import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/listeners/ordinator/listener_cmd.dart';

import 'ordinator/listener_cmd_error.dart';
import 'ordinator/listener_ready.dart';

void registerListeners(NyxxGateway client, CommandsPlugin commands) {
  onReadyListener(client);
  onCommandErrorListener(commands);
  onCommandListener(commands);
  // Add more listener registrations here
}
