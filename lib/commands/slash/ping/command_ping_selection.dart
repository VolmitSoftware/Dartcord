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

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

final pingSelection = ChatCommand(
  'pingselection',
  "Get the bot's latency, via selection",
  (ChatContext context) async {
    final selection = await context.getSelection(
      ['Basic', 'Real', 'Gateway'],
      MessageBuilder(content: 'Choose the latency metric you want to see'),
    );
    Duration latency;
    switch (selection) {
      case 'Basic':
        latency = context.client.httpHandler.latency;
        break;
      case 'Real':
        latency = context.client.httpHandler.realLatency;
        break;
      case 'Gateway':
        latency = context.client.gateway.latency;
        break;
      default:
        throw StateError('Unexpected selection $selection');
    }

    final formattedLatency = (latency.inMicroseconds / Duration.microsecondsPerMillisecond).toStringAsFixed(3);

    await context.respond(MessageBuilder(content: '${formattedLatency}ms'));
  },
);
