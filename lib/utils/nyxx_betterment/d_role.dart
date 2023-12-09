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

class DRole {
  /// This will find the default role for a guild. (@everyone)
  ///
  /// Accepts [guild] which is the guild to find the default role for.\
  /// Returns a [Role] object.
  ///
  /// Example:
  static Future<Role> everyoneRole({required guild}) async {
    return await guild.roles.list().then(
        (value) => value.firstWhere((element) => element.name == "@everyone"));
  }

  /// This will find the default role for a guild. (@everyone)
  ///
  /// Accepts [guild] which is the guild to find the default role for.\
  /// Returns a [Snowflake] object.
  ///
  /// Example:
  static Future<Snowflake> everyoneRoleID({required guild}) async {
    return await guild.roles.list().then((value) =>
        value.firstWhere((element) => element.name == "@everyone").id);
  }

  /// This will find a role by name in a guild.
  ///
  /// Accepts [guild] which is the guild to find the role in.\
  /// Accepts [roleName] which is the name of the role to find.\
  /// Returns a [Role] object.
  ///
  /// Example:
  static Future<Role> findRoleByName(
      {required guild, required roleName}) async {
    return await guild.roles.list().then(
        (value) => value.firstWhere((element) => element.name == roleName));
  }

  /// This will find a role by name in a guild.
  ///
  /// Accepts [guild] which is the guild to find the role in.\
  /// Accepts [roleName] which is the name of the role to find.\
  /// Returns a [Snowflake] object.
  ///
  /// Example:
  static Future<Snowflake> findRoleByNameID(
      {required guild, required roleName}) async {
    return await guild.roles.list().then(
        (value) => value.firstWhere((element) => element.name == roleName).id);
  }

  /// This will find a role by ID in a guild.
  ///
  /// Accepts [guild] which is the guild to find the role in.\
  /// Accepts [roleID] which is the ID of the role to find.\
  /// Returns a [Role] object.
  ///
  /// Example:
  static Future<Role> findRoleByID({required guild, required roleID}) async {
    return await guild.roles
        .list()
        .then((value) => value.firstWhere((element) => element.id == roleID));
  }

  /// This will find a role by ID in a guild.
  ///
  /// Accepts [guild] which is the guild to find the role in.\
  /// Accepts [roleID] which is the ID of the role to find.\
  /// Returns a [Snowflake] object.
  ///
  /// Example:
  static Future<Snowflake> findRoleByIDID(
      {required guild, required roleID}) async {
    return await guild.roles.list().then(
        (value) => value.firstWhere((element) => element.id == roleID).id);
  }
}
