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
import 'package:running_on_dart/utils/nyxx_betterment/e_embed.dart';

final cat =
    ChatCommand('cat_embed', "Le' Mew meow!", (ChatContext context) async {
  verbose("Command invoked: cat_embed");

  try {
    // Using Custom Embed
    var embed = await d_embed(fields: [
      EmbedFieldBuilder(name: "Behold", value: "The cat!", isInline: true)
    ]);
    await context.respond(MessageBuilder(embeds: [embed]),
        level: ResponseLevel.private);

    verbose("Cat embed message sent.");
  } catch (e) {
    error("Error in cat_embed command: ${e.toString()}");
    await context.respond(MessageBuilder(content: "An error occurred."),
        level: ResponseLevel.private);
  }
});
