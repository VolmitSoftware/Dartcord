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

Future<EmbedBuilder> dartcordEmbed({
  required List<EmbedFieldBuilder> fields,
  String? title,
  String? authorName,
  String? authorUrl,
  String? color,
  bool? timestamp,
  String? thumbnailUrl,
  String? imageUrl,
  String? description,
  String? footerText,
  String? footerIconUrl,
}) async {
  title ??= 'Im an Embed!';
  authorName ??= 'Someone, Far Away';
  authorUrl ??= 'https://volmit.com/';
  color ??= '#003865';
  thumbnailUrl ??= null;
  imageUrl ??= null;
  description ??= null;
  footerText ??= 'Made by Brian Fopiano ⚫️ ArcaneArts';
  footerIconUrl ??=
      'https://storage.googleapis.com/psycho_upload/clistogastra-landimere-premake-goddammit.heic';

  verbose("Generating Embed $title");
  return EmbedBuilder()
    ..title = title
    ..author = EmbedAuthorBuilder(name: authorName, url: Uri.parse(authorUrl))
    ..color = DiscordColor.parseHexString(color)
    ..timestamp = timestamp == true ? DateTime.now() : null
    ..fields = fields
    ..thumbnail = thumbnailUrl == null
        ? null
        : EmbedThumbnailBuilder(url: Uri.parse(thumbnailUrl))
    ..image =
        imageUrl == null ? null : EmbedImageBuilder(url: Uri.parse(imageUrl))
    ..description = description
    ..footer =
        EmbedFooterBuilder(text: footerText, iconUrl: Uri.parse(footerIconUrl));
}
