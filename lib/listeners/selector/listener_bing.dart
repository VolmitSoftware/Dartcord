/*
 *  -   Dartcord is a Discord bot template in Dart for public Use
 *  -   Copyright (c) 2023 Arcane Arts (Volmit Software)
 *  -
 *  -   This program is free software: you can redistribute it and/or modify
 *  -   it under the terms of the GNU General Public License as published by
 *  -   the Free Software Foundation, either version 3 of the License, or
 *  -   (at your option) any later version.
 *  -
 *  -   This program is distributed in the hope that it will be useful,
 *  -   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  -   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  -   GNU General Public License for more details.
 *  -
 *  -   You should have received a copy of the GNU General Public License
 *  -   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:fast_log/fast_log.dart';
import 'package:nyxx/nyxx.dart';
import 'package:running_on_dart/utils/prefab/selection_menu.dart';
import 'package:running_on_dart/utils/prefab/selection_menu_component.dart';

void onBingButtonListener(NyxxGateway client) {
  verbose("Registering Bing button listener");
  client.onMessageComponentInteraction.listen((event) async {
    if (event.interaction.type == InteractionType.messageComponent &&
        event.interaction.data.customId == "bing") {
      // Acknowledge the interaction (NEEDED IF NON-Ephemeral (See Dog as an Example))
      await event.interaction.acknowledge();

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
      var selectionMenu = await dartcordSelectionMenu(
        customId: "selection_menu_demo",
        options: options,
        placeholder: "Choose an option",
      );

      // Construct the message with the selection menu
      var message = MessageBuilder()
        ..components = [
          ActionRowBuilder(components: [selectionMenu])
        ];

      // Send the selection menu as a follow-up message
      await event.interaction.createFollowup(message);
    }
  });
}
