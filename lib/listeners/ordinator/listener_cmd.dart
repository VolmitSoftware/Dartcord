import 'package:nyxx_commands/nyxx_commands.dart';

void onCommandListener(CommandsPlugin commands) {
  commands.onPreCall.listen((event) async {
    print('Executing: Command: $event');
  });

  commands.onPostCall.listen((event) async {
    print('Completed: Command: $event');
  });
}
