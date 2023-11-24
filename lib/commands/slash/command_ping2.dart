// Imports will be ommitted in code samples below
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

final ping2 = ChatCommand(
  'ping2',
  "Get the bot's latency",
  (ChatContext context, [String? selection]) async {
    selection ??= await context.getSelection<String>(
      ['Basic', 'Real', 'Gateway'],
      MessageBuilder(content: 'Choose the latency metric you want to see'),
    );
  },
);
