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
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/utils/nyxx_betterment/d_button.dart';

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
          buttons.add(d_button(
              label: "Cat!", style: ButtonStyle.secondary, customId: "cat"));
          info("One button added.");
          break;
        case 'TWO':
          buttons
            ..add(d_button(
                label: "One!", style: ButtonStyle.secondary, customId: "cat"))
            ..add(d_button(
                label: "Two!", style: ButtonStyle.secondary, customId: "bing"));
          info("Two buttons added.");
          break;
        case 'THREE':
          buttons
            ..add(d_button(
                label: "One!", style: ButtonStyle.secondary, customId: "cat"))
            ..add(d_button(
                label: "Two!", style: ButtonStyle.secondary, customId: "bing"))
            ..add(d_button(
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
