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
    List<ButtonBuilder> buttons = [];

    switch (selection) {
      case 'ONE':
        buttons.add(dartcordButton(label: "Cat!", style: ButtonStyle.secondary, customId: "cat"));
        break;
      case 'TWO':
        buttons
          ..add(dartcordButton(label: "One!", style: ButtonStyle.secondary, customId: "one"))
          ..add(dartcordButton(label: "Two!", style: ButtonStyle.secondary, customId: "two"));
        break;
      case 'THREE':
        buttons
          ..add(dartcordButton(label: "One!", style: ButtonStyle.secondary, customId: "one"))
          ..add(dartcordButton(label: "Two!", style: ButtonStyle.secondary, customId: "two"))
          ..add(dartcordButton(label: "Dog!", style: ButtonStyle.secondary, customId: "dog"));
        break;
      default:
        throw StateError('Unexpected selection $selection');
    }

    // Construct the message with buttons
    var message = MessageBuilder()
      ..content = 'Buttons will be here!'
      ..components = [ActionRowBuilder(components: buttons)];
    await context.respond(message, level: buttons.length == 3 ? ResponseLevel.private : ResponseLevel.public);
  },
);
