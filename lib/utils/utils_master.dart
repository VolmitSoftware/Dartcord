import 'package:nyxx/nyxx.dart';
import 'package:running_on_dart/main.dart';

class BotTools {
  /// Checks if a given entity is a bot.
  ///
  /// Accepts [entity] which can be a User, Member, Snowflake (ID), or Message.
  ///
  /// Returns `true` if the entity is a bot, otherwise `false`.
  static Future<bool> isBot(dynamic entity) async {
    switch (entity.runtimeType) {
      case User:
        return (entity as User).isBot;
      case Member:
        return isBot((entity as Member).id);
      case Snowflake:
        User user = await nyxxBotClient.user.manager.get(entity as Snowflake);
        return user.isBot;
      case Message:
        return isBot((entity as MessageCreateEvent).message.author.id);
      default:
        return false;
    }
  }

  /// Checks if a given message contains variations of "im".
  ///
  /// [message] is the message text to be checked.
  ///
  /// Returns `true` if variations of "im" are found in the message, otherwise `false`.
  static bool messageHas(String message) {
    RegExp imRegex = RegExp(r"\bim\b", caseSensitive: false);
    return imRegex.hasMatch(message);
  }

  /// Checks if a given message exactly contains "Dartcord".
  ///
  /// [message] is the message text to be checked.
  ///
  /// Returns `true` if the message contains "Dartcord", otherwise `false`.
  static bool messageHasExact(String message) {
    return message.contains("Dartcord");
  }
}