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

import 'package:fast_log/fast_log.dart';

enum BotDataField {
  activeTickets,
  totalTickets,
  staffChat,
  lockedChats,
  lastStartTime
}

class BotData {
  String lastStartTime;
  int activeTickets;
  int totalTickets;
  String staffChat;
  List<String> lockedChats;

  BotData({
    this.lastStartTime = '',
    this.activeTickets = 0,
    this.totalTickets = 0,
    this.staffChat = '',
    this.lockedChats = const [],
  });

  dynamic getField(BotDataField field) {
    verbose("Getting bot data field: $field");
    switch (field) {
      case BotDataField.lastStartTime:
        return activeTickets;
      case BotDataField.activeTickets:
        return activeTickets;
      case BotDataField.totalTickets:
        return totalTickets;
      case BotDataField.staffChat:
        return staffChat;
      case BotDataField.lockedChats:
        return lockedChats;
      default:
        throw ArgumentError('Invalid BotDataField');
    }
  }

  void setField(BotDataField field, dynamic value) async {
    verbose("Setting bot data field: $field to $value");
    switch (field) {
      case BotDataField.lastStartTime:
        lastStartTime = value as String;
        break;
      case BotDataField.activeTickets:
        activeTickets = value as int;
        break;
      case BotDataField.totalTickets:
        totalTickets = value as int;
        break;
      case BotDataField.staffChat:
        staffChat = value as String;
        break;
      case BotDataField.lockedChats:
        lockedChats = value as List<String>;
        break;
      default:
        throw ArgumentError('Invalid BotDataField');
    }
    await saveToFile();
  }

  Future<void> newTicket() async {
    verbose("New ticket created.");
    await updateDataFromBotFile();
    totalTickets += 1;
    activeTickets += 1;
    await saveToFile();
  }

  Future<void> removeTicket() async {
    verbose("Ticket removed, decrementing active tickets.");
    await updateDataFromBotFile();
    if (activeTickets > 0) {
      activeTickets -= 1;
    }
    await saveToFile();
  }

  void reset() async {
    error("Bot data reset.");
    lastStartTime = '';
    activeTickets = 0;
    totalTickets = 0;
    staffChat = '';
    lockedChats = [];
    await saveToFile();
  }

  static const String filePath = './Data/Bot.json';

  Future<void> saveToFile() async {
    verbose("Saving bot data to file.");
    final file = File(filePath);
    final directory = file.parent;

    // Create the directory if it doesn't exist
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Save data to the file
    await file.writeAsString(jsonEncode({
      'lastStartTime': lastStartTime,
      'activeTickets': activeTickets,
      'totalTickets': totalTickets,
      'staffChat': staffChat,
      'lockedChats': lockedChats,
    }));
  }

  Future<void> updateDataFromBotFile() async {
    verbose("Updating bot data from file.");
    final botData = await loadFromFile();
    lastStartTime = botData.lastStartTime;
    activeTickets = botData.activeTickets;
    totalTickets = botData.totalTickets;
    staffChat = botData.staffChat;
    lockedChats = botData.lockedChats;
  }

  static Future<BotData> loadFromFile() async {
    verbose("Loading bot data from file.");
    final file = File(filePath);
    if (await file.exists()) {
      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents);
      return BotData(
        lastStartTime: jsonData['lastStartTime'],
        activeTickets: jsonData['activeTickets'],
        totalTickets: jsonData['totalTickets'],
        staffChat: jsonData['staffChat'],
        lockedChats: List<String>.from(jsonData['lockedChats']),
      );
    }
    return BotData();
  }
}
