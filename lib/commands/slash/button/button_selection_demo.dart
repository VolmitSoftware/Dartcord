import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/utils/prefab/selection_menu.dart';
import 'package:running_on_dart/utils/prefab/selection_menu_component.dart';

final selectionMenuDemo = ChatCommand(
  'selectionmenudemo',
  "Showcases a demo for selection menus!",
  (ChatContext context) async {
    // Define options for the selection menu
    var options = [
      dartcordSelectionMenuOption(
        label: "Option 1",
        value: "option_1",
        description: "Description for option 1",
      ),
      dartcordSelectionMenuOption(
        label: "Option 2",
        value: "option_2",
        description: "Description for option 2",
      ),
    ];

    // Create the selection menu
    var selectionMenu = await dartcordSelectionMenu(customId: "selection_menu_demo", options: options, placeholder: "Choose an option", maxValues: 2, minValues: 0);

    // Construct the message with the selection menu
    var message = MessageBuilder()
      ..content = 'Selection menu will be here!'
      ..components = [
        ActionRowBuilder(components: [selectionMenu])
      ];
    await context.respond(message, level: ResponseLevel.public);
  },
);
