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
import 'package:nyxx_commands/nyxx_commands.dart';

class DMessage {
  /// Sends a message to a specified entity (channel, ChatContext, or Message).
  ///
  /// [entity] - Can be a TextChannel, ChatContext, or Message where the message will be sent.
  /// [messageBuilder] - The message to be sent.
  ///
  /// Returns the sent Message if successful, otherwise `null`.
  static Future<Message?> sendMessage(
      {required dynamic entity, required MessageBuilder messageBuilder}) async {
    try {
      if (entity is TextChannel) {
        verbose("Sending message to channel: ${entity.id}");
        return await entity.sendMessage(messageBuilder);
      } else if (entity is ChatContext || entity is Message) {
        verbose("Sending message to ${entity.channel.id}");
        return await entity.channel.sendMessage(messageBuilder);
      } else {
        error("Unknown entity type for sendMessage: ${entity.runtimeType}");
        return null;
      }
    } catch (e) {
      error("Error sending message: $e");
      return null;
    }
  }

  /// Deletes a message and returns a boolean indicating success.
  ///
  /// Accepts [message] which is the message to be deleted.
  ///
  /// Returns `true` if successful, otherwise `false`.
  static Future<bool> deleteMessage({required Message message}) async {
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
