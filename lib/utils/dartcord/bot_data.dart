import 'dart:convert';
import 'dart:io';

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

  void setField(BotDataField field, dynamic value) {
    switch (field) {
      case BotDataField.lastStartTime:
        activeTickets = value as int;
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
  }

  void reset() {
    lastStartTime = '';
    activeTickets = 0;
    totalTickets = 0;
    staffChat = '';
    lockedChats = [];
  }

  static const String filePath = './Data/Bot.json';

  Future<void> saveToFile() async {
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

  static Future<BotData> loadFromFile() async {
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
