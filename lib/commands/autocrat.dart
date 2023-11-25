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

import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/commands/slash/embed/cat_embed.dart';
import 'package:running_on_dart/commands/slash/embed/embed.dart';
import 'package:running_on_dart/commands/slash/ping/command_ping_choices.dart';
import 'package:running_on_dart/commands/slash/ping/command_ping_selection.dart';
import 'package:running_on_dart/commands/slash/ping/command_ping_string.dart';

void autocrat(CommandsPlugin commands) {
  commands..addCommand(pingSelection);
  commands..addCommand(pingString);
  commands..addCommand(pingChoices);
  commands..addCommand(embed);
  commands..addCommand(cat);

  // Add more commands here
  ;
}
