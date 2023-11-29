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

class DMessage {
  /// Sends a message to a specified channel.
  ///
  /// Accepts [channel] which is the channel where the message will be sent.
  /// Accepts [messageBuilder] which is the message to be sent.
  ///
  /// Returns the sent Message if successful, otherwise `null`.
  static Future<Message?> sendMessageToChannel(
      TextChannel channel, MessageBuilder messageBuilder) async {
    try {
      verbose("Sending message to channel: ${channel.id}");
      Message sentMessage = await channel.sendMessage(messageBuilder);
      return sentMessage;
    } catch (e) {
      error("Failed to send message to channel: ${channel.id}, Error: $e");
      return null;
    }
  }

  /// Deletes a message and returns a boolean indicating success.
  ///
  /// Accepts [message] which is the message to be deleted.
  ///
  /// Returns `true` if successful, otherwise `false`.
  static Future<bool> deleteMessage(Message message) async {
    try {
      verbose("Deleting message from channel: ${message.channel.id}");
      await message.delete();
      return true;
    } catch (e) {
      error("Failed to delete message: $e");
      return false;
    }
  }
}
