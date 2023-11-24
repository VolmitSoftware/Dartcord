import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

final pingSelection = ChatCommand(
  'pingselection',
  "Get the bot's latency, via selection",
  (ChatContext context) async {
    final selection = await context.getSelection(
      ['Basic', 'Real', 'Gateway'],
      MessageBuilder(content: 'Choose the latency metric you want to see'),
    );
    Duration latency;
    switch (selection) {
      case 'Basic':
        latency = context.client.httpHandler.latency;
        break;
      case 'Real':
        latency = context.client.httpHandler.realLatency;
        break;
      case 'Gateway':
        latency = context.client.gateway.latency;
        break;
      default:
        throw StateError('Unexpected selection $selection');
    }

    final formattedLatency = (latency.inMicroseconds / Duration.microsecondsPerMillisecond).toStringAsFixed(3);

    await context.respond(MessageBuilder(content: '${formattedLatency}ms'));
  },
);
