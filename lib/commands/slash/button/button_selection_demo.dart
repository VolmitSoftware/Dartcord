/*
 * This is a project by ArcaneArts, for free/public use!
 * Copyright (c) 2023 Arcane Arts (Volmit Software)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:fast_log/fast_log.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/utils/prefab/selection_menu.dart';
import 'package:running_on_dart/utils/prefab/selection_menu_component.dart';

final selectionMenuDemo = ChatCommand(
  'selectionmenudemo',
  "Showcases a demo for selection menus!",
  (ChatContext context) async {
    verbose("Command invoked: selectionmenudemo");

    try {
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
      verbose("Selection menu options defined.");

      // Create the selection menu
      var selectionMenu = await dartcordSelectionMenu(
          customId: "selection_menu_demo",
          options: options,
          placeholder: "Choose an option",
          maxValues: 2,
          minValues: 0);
      verbose("Selection menu created.");

      // Construct the message with the selection menu
      var message = MessageBuilder()
        ..content = 'Selection menu will be here!'
        ..components = [
          ActionRowBuilder(components: [selectionMenu])
        ];

      await context.respond(message, level: ResponseLevel.public);
      verbose("Message with selection menu sent.");
    } catch (e) {
      error("Error in selectionMenuDemo: ${e.toString()}");
      await context.respond(MessageBuilder(content: "An error occurred."),
          level: ResponseLevel.private);
    }
  },
);
