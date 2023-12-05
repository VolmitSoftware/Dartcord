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

void onTicketButtonPress(NyxxGateway client) {
  verbose("Registering Dog button listener");
  // This one uses Followup messages, or it will crash the bot because the response is not unique
  client.onMessageComponentInteraction.listen((event) async {
    if (event.interaction.type == InteractionType.messageComponent &&
        event.interaction.data.customId == "make-ticket") {
      verbose("Ticket button pressed by: ${event.interaction.user}!");

      //TODO: Make a ticket, and update the number of tickets in the database
    }
  });
}
