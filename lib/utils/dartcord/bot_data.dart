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
  lastStartTime,
  ticketCountMap
}

class BotData {
  String lastStartTime;
  int activeTickets;
  int totalTickets;
  String staffChat;
  List<String> lockedChats;
  Map<String, int> ticketCountMap;

  BotData({
    this.lastStartTime = '',
    this.activeTickets = 0,
    this.totalTickets = 0,
    this.staffChat = '',
    this.lockedChats = const [],
    this.ticketCountMap = const {},
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
      case BotDataField.ticketCountMap:
        return ticketCountMap;
      default:
        throw ArgumentError('Invalid BotDataField');
    }
  }

  void incrementTickets() {
    activeTickets++;
    totalTickets++;
  }

  void decrementTickets() {
    activeTickets--;
  }

  void updateTicketCountMapKey(String key, [int valueToAdd = 1]) {
    if (ticketCountMap.containsKey(key)) {
      ticketCountMap[key] = ticketCountMap[key]! + valueToAdd;
    } else {
      ticketCountMap[key] = valueToAdd;
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
        lockedChats = value == null ? [] : List<String>.from(value);
        break;
      case BotDataField.ticketCountMap:
        ticketCountMap = value == null ? {} : Map<String, int>.from(value);
        break;
      default:
        throw ArgumentError('Invalid BotDataField');
    }
    await saveToFile();
  }

  void reset() async {
    error("Bot data reset.");
    lastStartTime = '';
    activeTickets = 0;
    totalTickets = 0;
    staffChat = '';
    lockedChats = List.of([]);
    ticketCountMap = Map.of({});
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
      'ticketCountMap': ticketCountMap,
    }));
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
        lockedChats: jsonData['lockedChats'] == null
            ? []
            : List<String>.from(jsonData['lockedChats']),
        ticketCountMap: jsonData['ticketCountMap'] == null
            ? {}
            : Map<String, int>.from(jsonData['ticketCountMap']),
      );
    }
    return BotData();
  }
}
