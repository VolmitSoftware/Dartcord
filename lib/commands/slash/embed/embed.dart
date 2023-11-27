/*
 *  -   Dartcord is a Discord bot template in Dart for public Use
 *  -   Copyright (c) 2023 Arcane Arts (Volmit Software)
 *  -
 *  -   This program is free software: you can redistribute it and/or modify
 *  -   it under the terms of the GNU General Public License as published by
 *  -   the Free Software Foundation, either version 3 of the License, or
 *  -   (at your option) any later version.
 *  -
 *  -   This program is distributed in the hope that it will be useful,
 *  -   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  -   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  -   GNU General Public License for more details.
 *  -
 *  -   You should have received a copy of the GNU General Public License
 *  -   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:fast_log/fast_log.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/bot_cfg.dart';

final embed = ChatCommand(
    'embed_embed', 'Creates an embed with provided title and footer',
    (ChatContext context,
        [@Description("This is where I put descriptions") String? title,
        @Description("Timestamp?") bool? timestamp,
        @Description("This is another one!") String? footer]) async {
  verbose(
      "Command invoked: embed_embed with title: ${title ?? 'Default'} and footer: ${footer ?? 'Default'}");

  try {
    // Set default values if null
    title ??= 'Default Title';

    footer ??= 'Default Footer';
    var username = context.user.username;

    // Create the embed
    var embed = EmbedBuilder()
      ..title = title
      ..author = EmbedAuthorBuilder(
          name: username, url: Uri.parse('https://github.com/NextdoorPsycho'))
      ..color = DiscordColor.parseHexString(BotCFG.i.botColor)
      ..timestamp = timestamp == true ? DateTime.now() : null
      ..fields = [
        EmbedFieldBuilder(
            name: "I'm inlined, and first!",
            value: "Hello reader",
            isInline: true),
        EmbedFieldBuilder(
            name: "I'm inlined, and second!",
            value: "Hello reader",
            isInline: true),
        EmbedFieldBuilder(
            name: "Some Non Inlined Embed part",
            value: "Hi, I'm not aligned",
            isInline: false),
        EmbedFieldBuilder(
            name: "Some Non Inlined Embed part",
            value: "Hi, I'm not aligned",
            isInline: false)
      ]
      ..thumbnail = EmbedThumbnailBuilder(
          url: Uri.parse(
              'https://cdn.discordapp.com/avatars/173261518572486656/a_63b6f52a118e915f11bc771985a078c8.gif?quality=lossless&size=4096'))
      ..image = EmbedImageBuilder(
          url: Uri.parse(
              'https://cdn.discordapp.com/avatars/173261518572486656/a_63b6f52a118e915f11bc771985a078c8.gif?quality=lossless&size=4096'))
      ..description =
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s."
      ..footer = EmbedFooterBuilder(
          text: "Made by: " + BotCFG.i.botCompanyName + " - " + footer,
          iconUrl: Uri.parse(BotCFG.i.botImageURL));

    await context.respond(MessageBuilder(embeds: [embed]),
        level: ResponseLevel.private);
    verbose("Embed message sent with title: $title and footer: $footer");
  } catch (e) {
    error("Error in embed_embed command: ${e.toString()}");
    await context.respond(MessageBuilder(content: "An error occurred."),
        level: ResponseLevel.private);
  }
});
