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
import 'package:running_on_dart/configurator.dart';
import 'package:running_on_dart/utils/data_util.dart';
import 'package:running_on_dart/utils/discord_extentions.dart';

void onMessageXPAwardListener(NyxxGateway client) {
  verbose("Registering XP award listener");
  client.onMessageCreate.listen((event) async {
    if (!await DUtil.isBot(event.message.author)) {
      var userId = event.message.author.id;
      var userData = await DataUtil.getUserData(userId);

      // Generate random XP
      double randomXP = Configurator.instance.getRandomXP();

      // Update XP
      userData['xp'] = (userData['xp'] as double? ?? 0.0) + randomXP;
      await DataUtil.saveUserData(userId, userData);

      // Optionally, send a confirmation message or log
      verbose("Awarded $randomXP XP to user ${event.message.author.username}");
    }
  });
}
