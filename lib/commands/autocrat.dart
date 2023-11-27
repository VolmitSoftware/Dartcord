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
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/commands/slash/button/button_demo.dart';
import 'package:running_on_dart/commands/slash/button/button_selection_demo.dart';
import 'package:running_on_dart/commands/slash/embed/embed.dart';
import 'package:running_on_dart/commands/slash/embed/embed_cat.dart';
import 'package:running_on_dart/commands/slash/image/Image_from_prompt.dart';
import 'package:running_on_dart/commands/slash/image/image_edit.dart';
import 'package:running_on_dart/commands/slash/image/image_variant.dart';
import 'package:running_on_dart/commands/slash/ping/ping_collection.dart';
import 'package:running_on_dart/commands/slash/ticket/ticket_collection.dart';

void autocrat(CommandsPlugin commands) {
  verbose("Registering commands");
  commands..addCommand(pingCluster);
  commands..addCommand(embed);
  commands..addCommand(cat);
  commands..addCommand(buttonDemo);
  commands..addCommand(selectionMenuDemo);
  commands..addCommand(image_vary);
  commands..addCommand(image_prompt);
  commands..addCommand(image_edit);
  commands..addCommand(ticketCluster);

  // Add more commands here
  ;
}
