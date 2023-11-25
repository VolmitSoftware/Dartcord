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
import 'package:running_on_dart/utils/utils_master.dart';

void onHiMessageListener(NyxxGateway client) {
  client.onMessageCreate.listen((event) async {
    //Simplified message parsing, and bot checking!
    if (BotTools.messageHas(event.message.content) && !await BotTools.isBot(event)) {
      await event.message.manager.create(MessageBuilder(
        content: "I'm Dartcord!",
        replyId: event.message.id,
      ));
    }
  });
}
