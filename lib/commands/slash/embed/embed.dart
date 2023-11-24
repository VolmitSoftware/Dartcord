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

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

final embed = ChatCommand('embed', 'Creates an embed with provided title and footer', (ChatContext context,
    [@Description("This is where i put descriptions") String? title,
    // @ResponseLevel(hideInteraction: true, isDm: false, mention: true, preserveComponentMessages: true)
    @Description("This is another one!") String? footer]) async {
  title = 'Default Title';
  footer ??= 'Default Footer';

  var embed = EmbedBuilder()
    ..title = title
    ..author = EmbedAuthorBuilder(name: 'NextdoorPsycho', url: Uri.parse('https://github.com/NextdoorPsycho'))
    ..color = DiscordColor.fromRgb(00, 51, 106)
    ..timestamp = DateTime.now()
    ..fields = [EmbedFieldBuilder(name: "Im inlined, and first!", value: "Hello reader", isInline: true), EmbedFieldBuilder(name: "Im inlined, and second!", value: "Hello reader", isInline: true), EmbedFieldBuilder(name: "Some Non Inlined Embed part", value: "Hi, im not alligned", isInline: false), EmbedFieldBuilder(name: "Some Non Inlined Embed part", value: "Hi, im not alligned", isInline: false)]
    ..thumbnail = EmbedThumbnailBuilder(url: Uri.parse('https://cdn.discordapp.com/avatars/173261518572486656/a_63b6f52a118e915f11bc771985a078c8.gif?quality=lossless&size=4096'))
    ..image = EmbedImageBuilder(url: Uri.parse('https://cdn.discordapp.com/avatars/173261518572486656/a_63b6f52a118e915f11bc771985a078c8.gif?quality=lossless&size=4096'))
    ..description = "Loriem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s."
    ..footer = EmbedFooterBuilder(text: footer, iconUrl: Uri.parse('https://cdn.discordapp.com/avatars/173261518572486656/a_63b6f52a118e915f11bc771985a078c8.gif?quality=lossless&size=4096'));
  await context.respond(MessageBuilder(embeds: [embed]), level: ResponseLevel.private);
});
