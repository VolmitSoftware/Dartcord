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

import 'dart:convert';
import 'dart:io';

enum UserDataField { xp, messageCount, activeTickets, warnings, roles }

class UserData {
  double xp;
  int messageCount;
  int activeTickets;
  int warnings;
  List<String> roles;
  String userId;

  UserData({
    required this.userId,
    this.xp = 0.0,
    this.messageCount = 0,
    this.activeTickets = 0,
    this.warnings = 0,
    this.roles = const [],
  });

  dynamic getField(UserDataField field) {
    switch (field) {
      case UserDataField.xp:
        return xp;
      case UserDataField.messageCount:
        return messageCount;
      case UserDataField.activeTickets:
        return activeTickets;
      case UserDataField.warnings:
        return warnings;
      case UserDataField.roles:
        return roles;
      default:
        throw ArgumentError('Invalid UserDataField');
    }
  }

  void setField(UserDataField field, dynamic value) {
    switch (field) {
      case UserDataField.xp:
        xp = value as double;
        break;
      case UserDataField.messageCount:
        messageCount = value as int;
        break;
      case UserDataField.activeTickets:
        activeTickets = value as int;
        break;
      case UserDataField.warnings:
        warnings = value as int;
        break;
      case UserDataField.roles:
        roles = value as List<String>;
        break;
      default:
        throw ArgumentError('Invalid UserDataField');
    }
  }

  void reset() {
    xp = 0.0;
    messageCount = 0;
    activeTickets = 0;
    warnings = 0;
    roles = [];
  }

  String get filePath => './Data/UserData/$userId.json';

  Future<void> saveToFile() async {
    final file = File(filePath);
    final directory = file.parent;

    // Create the directory if it doesn't exist
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Save data to the file
    await file.writeAsString(jsonEncode({
      'xp': xp,
      'messageCount': messageCount,
      'activeTickets': activeTickets,
      'warnings': warnings,
      'roles': roles,
    }));
  }

  static Future<UserData?> loadFromFile(String userId) async {
    final file = File('./Data/$userId.json');
    if (await file.exists()) {
      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents);
      return UserData(
        userId: userId,
        xp: jsonData['xp'],
        messageCount: jsonData['messageCount'],
        activeTickets: jsonData['activeTickets'],
        warnings: jsonData['warnings'],
        roles: List<String>.from(jsonData['roles']),
      );
    }
    return null;
  }
}
