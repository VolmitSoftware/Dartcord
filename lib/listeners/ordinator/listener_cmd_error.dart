import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

void onCommandErrorListener(CommandsPlugin commands) {
  commands.onCommandError.listen((error) async {
    if (error is ConverterFailedException) {
      if (error.context is InteractiveContext) {
        final InteractiveContext context = error.context as InteractiveContext;
        await context.respond(MessageBuilder(
          content: 'Invalid input: `${error.input.remaining}`',
        ));
      }
    } else {
      print('Uncaught error: $error');
    }
  });
}
