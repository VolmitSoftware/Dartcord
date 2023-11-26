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

import 'dart:ffi';

import 'package:nyxx_commands/nyxx_commands.dart';

/*
  * This is the ticketing system. It is a work in progress, and will be updated as time goes on.
  * But here is what it needs to be able to do:
  * - Create a ticket Hub, which is a category with a bunch of channels in it, and 1 that is the ticket hub
  * - Create a ticket, which is a channel in the ticket hub, when said button is pressed.
  * - Be able to add people to the ticket, and remove them. /ticket add <ID>, /ticket remove <ID> (Mod only)
  * - Be able to close the ticket, and archive it. /ticket close (Mod/Creator only) (Or click the button in the ticket)
  * - BE able to save the history of the ticket, and be able to view it later. /ticket history <ID> (Mod/Creator only)
  * - be able to just type /ticket create anywhere to create a ticket, and add the user to it.
 */

final ticketCluster = ChatGroup("ticket",
    "The root command that drives ticket creation, manipulation, and so on.",
    children: [
      ChatCommand(
        'build-hub',
        "Create the whole ticketing system, including the hub, and the ticket creation button.",
        (ChatContext context) async {
          //TODO Create the ticketing system
        },
      ),
      ChatCommand(
        'create',
        "Create a ticket, and add the user to it.",
        (ChatContext context) async {
          //TODO Create a ticket, and add the user to it.
        },
      ),
      ChatCommand(
        'users',
        "Add or Remove a user from a ticket.",
        (
          ChatContext context, [
          @Choices({
            'Add': true,
            'Remove': false,
          })
          @Description('Add or Remove a user from a ticket.')
          Bool? selection,
          @Description('The user to add or remove. (Right-click Copy ID)')
          String? userId,
        ]) async {
          //TODO Add a user to a ticket.
        },
      ),
      ChatCommand(
        'close',
        "Close a ticket, and archive it.",
        (ChatContext context) async {
          //TODO Close a ticket, and archive it.
        },
      ),
      ChatCommand(
        'history',
        "View the history of a ticket.",
        (
          ChatContext context, [
          @Description(
              'The Ticket number you want to view the history of (The 00000 number)')
          String? ticketId,
        ]) async {
          //TODO View the history of a ticket.
        },
      )
    ]);
