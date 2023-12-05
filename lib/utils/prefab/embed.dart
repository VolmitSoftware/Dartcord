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

import 'package:nyxx/nyxx.dart';

Future<EmbedBuilder> ticketCenterEmbed() async {
  return EmbedBuilder()
    ..title = 'Welcome to the Ticket Center!'
    ..description =
        'If you want to create a ticket, just click the button below!\n\n'
            '**TICKETS ARE FOR:**\n'
            '- Commissioned projects\n'
            '- Private/Developer Support\n'
            '- Reporting Illegal activity (Spam, Phishing, etc...)\n'
            '- Business Inquiries\n\n'
            '**TICKETS ARE NOT FOR:**\n'
            '- General Support (Use the chats for that)\n'
            '- Plugin Support/Questions (Also use chats for that)\n'
            '- General Chit Chat'
    ..color = DiscordColor.parseHexString('#003865');
}
