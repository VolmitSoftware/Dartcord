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

class DPerms {
  /// Add a user to a channel (edit the permissions to allow a user to read a channel)
  ///
  /// Accepts [user] which is the user to add to the channel.
  /// Accepts [channel] which is the channel to add the user to.
  /// Accepts [channelPermission]
  ///
  /// Returns `true` if successful, otherwise `false`.
  static Future<bool> channelPermAddUser(
      {required Flag<Permissions> permission,
      required Snowflake userSnowflake,
      required Channel channel}) async {
    try {
      channel.manager.updatePermissionOverwrite(
          channel.id,
          PermissionOverwriteBuilder(
              id: userSnowflake,
              type: PermissionOverwriteType.member,
              allow: permission));
      return true;
    } catch (e) {
      error(e);
      return false;
    }
  }

  /// Add a user to a channel (edit the permissions to allow a user to read a channel)
  ///
  /// Accepts [user] which is the user to add to the channel.
  /// Accepts [channel] which is the channel to add the user to.
  /// Accepts [channelPermission]
  ///
  /// Returns `true` if successful, otherwise `false`.
  static Future<bool> channelPermRemoveUser(
      {required Flag<Permissions> permission,
      required Snowflake userSnowflake,
      required Channel channel}) async {
    try {
      channel.manager.updatePermissionOverwrite(
          channel.id,
          PermissionOverwriteBuilder(
              id: userSnowflake,
              type: PermissionOverwriteType.member,
              deny: permission));
      return true;
    } catch (e) {
      error(e);
      return false;
    }
  }

  /// Add a Role to a channel (edit the permissions to allow a user to read a channel)
  ///
  /// Accepts [user] which is the user to add to the channel.
  /// Accepts [channel] which is the channel to add the user to.
  /// Accepts [channelPermission]
  ///
  /// Returns `true` if successful, otherwise `false`.
  static Future<bool> channelPermAddRole(
      {required Flag<Permissions> permission,
      required Snowflake roleSnowflake,
      required Channel channel}) async {
    try {
      channel.manager.updatePermissionOverwrite(
          channel.id,
          PermissionOverwriteBuilder(
              id: roleSnowflake,
              type: PermissionOverwriteType.role,
              allow: permission));
      return true;
    } catch (e) {
      error(e);
      return false;
    }
  }

  /// Remo a Role to a channel (edit the permissions to allow a user to read a channel)
  ///
  /// Accepts [user] which is the user to add to the channel.
  /// Accepts [channel] which is the channel to add the user to.
  /// Accepts [channelPermission]
  ///
  /// Returns `true` if successful, otherwise `false`.
  Future<bool> channelPermRemoveRole(
      {required Flag<Permissions> permission,
      required Snowflake roleSnowflake,
      required Channel channel}) async {
    try {
      channel.manager.updatePermissionOverwrite(
          channel.id,
          PermissionOverwriteBuilder(
              id: roleSnowflake,
              type: PermissionOverwriteType.role,
              deny: permission));
      return true;
    } catch (e) {
      error(e);
      return false;
    }
  }
}
