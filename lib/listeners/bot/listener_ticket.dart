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
import 'package:running_on_dart/utils/dartcord/bot_data.dart';
import 'package:running_on_dart/utils/nyxx_betterment/d_channel.dart';

void onTicketIncListener(NyxxGateway client) {
  verbose("Registering Hi Ticket listeners");
  client.onMessageCreate.listen((event) async {
    // Check for guild before processing
    if ((await event.guild?.manager.get(event.guildId!)) != null) {
      var channel = await DChannel.findChannelById(
          channelId: event.message.channelId,
          guild: await event.guild!.manager.get(event.guildId!),
          channelType: ChannelType.guildText);
      if (channel?.name.startsWith("ticket-") == true) {
        var ticketId = channel?.name.split('-')[1];

        BotData().updateTicketCountMapKey(ticketId!, 1);

        await event.message.manager.create(MessageBuilder(
          content: "This is ticket ID: $ticketId",
          replyId: event.message.id,
        ));
      }
    }
  });
}
