import 'package:fast_log/fast_log.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/utils/prefab/button.dart';

final buttonDemo = ChatCommand(
  'buttondemo',
  "Showcases a demo for buttons and interactions!",
  (
    ChatContext context, [
    @Choices({
      '1 Button': 'ONE',
      '2 Buttons': 'TWO',
      '3 Buttons': 'THREE',
    })
    @Description('Numeral for buttons to showcase')
    String? selection,
  ]) async {
    verbose("Command invoked: buttondemo with selection: $selection");

    List<ButtonBuilder> buttons = [];

    try {
      switch (selection) {
        case 'ONE':
          buttons.add(dartcordButton(
              label: "Cat!", style: ButtonStyle.secondary, customId: "cat"));
          info("One button added.");
          break;
        case 'TWO':
          buttons
            ..add(dartcordButton(
                label: "One!", style: ButtonStyle.secondary, customId: "cat"))
            ..add(dartcordButton(
                label: "Two!", style: ButtonStyle.secondary, customId: "bing"));
          info("Two buttons added.");
          break;
        case 'THREE':
          buttons
            ..add(dartcordButton(
                label: "One!", style: ButtonStyle.secondary, customId: "cat"))
            ..add(dartcordButton(
                label: "Two!", style: ButtonStyle.secondary, customId: "bing"))
            ..add(dartcordButton(
                label: "Dog!", style: ButtonStyle.secondary, customId: "dog"));
          info("Three buttons added.");
          break;
        default:
          error("Unexpected selection: $selection");
          throw StateError('Unexpected selection $selection');
      }

      // Construct the message with buttons
      var message = MessageBuilder()
        ..content = 'Buttons will be here!'
        ..components = [ActionRowBuilder(components: buttons)];

      await context.respond(message,
          level: buttons.length == 3
              ? ResponseLevel.private
              : ResponseLevel.public);
      verbose("Message with buttons sent.");
    } catch (e) {
      error("Error in buttonDemo: ${e.toString()}");
      await context.respond(MessageBuilder(content: "An error occurred."),
          level: ResponseLevel.private);
    }
  },
);
