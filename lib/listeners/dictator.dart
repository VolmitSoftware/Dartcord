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
import 'package:running_on_dart/listeners/bot/listener_cmd.dart';
import 'package:running_on_dart/listeners/bot/listener_cmd_error.dart';
import 'package:running_on_dart/listeners/bot/listener_ready.dart';
import 'package:running_on_dart/listeners/button/dog_listener.dart';
import 'package:running_on_dart/listeners/other/listener_hello.dart';
import 'package:running_on_dart/listeners/other/listener_xp.dart';
import 'package:running_on_dart/listeners/other/ticket_listener.dart';
import 'package:running_on_dart/listeners/selector/listener_bing.dart';

import 'button/cat_listener.dart';

void registerListeners(NyxxGateway client, CommandsPlugin commands) {
  verbose("Registering listeners");
  onReadyListener(client);
  onCommandErrorListener(commands);
  onCommandListener(commands);
  onCatButtonListener(client);
  onDogButtonListener(client);
  onBingButtonListener(client);
  onHiMessageListener(client);
  onMessageXPAwardListener(client);
  onTicketButtonPress(client);
// Add more listener registrations here
}
