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

class DUtil {
  /// Checks if a given message contains variations of "im".
  ///
  /// [message] is the message text to be checked.
  ///
  /// Returns `true` if variations of "im" are found in the message, otherwise `false`.
  static bool messageHas({required String message}) {
    RegExp imRegex = RegExp(r"\bim\b", caseSensitive: false);
    return imRegex.hasMatch(message);
  }

  static String getId({required dynamic entity}) {
    switch (entity.runtimeType) {
      case User:
        return (entity as User).id.toString();
      case Member:
        return (entity as Member).id.toString();
      case Snowflake:
        return (entity as Snowflake).toString();
      case Message:
        return (entity as MessageCreateEvent).message.id.toString();
      case WebhookAuthor:
        return (entity as WebhookAuthor).id.toString();
      default:
        error("Unknown entity type{Arbitrary}: ${entity.runtimeType}");
        return "";
    }
  }

  static dataPath() {
    return "./Data/";
  }

  static snowflakePath({required dynamic entity}) {
    return "./Data/" + getId(entity: entity) + "/";
  }

  static bool messageHasExact(String content, String match) {
    return content.contains(match);
  }
}
