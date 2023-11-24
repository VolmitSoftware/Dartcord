// Imports will be ommitted in code samples below
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

final ping3 = ChatCommand(
  'ping3',
  "Get the bot's latency",
  (
    ChatContext context, [
    @Choices({
      'Basic latency': 'Basic',
      'Real latency': 'Real',
      'Gateway latency': 'Gateway',
    })
    @Description('The type of latency to view')
    String? selection,
  ]) async {
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
