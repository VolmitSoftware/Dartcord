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

Future<EmbedBuilder> d_embed({
  List<EmbedFieldBuilder>? fields,
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
  title ??= 'Dartcord Embed Title';
  authorName ??= 'Dartcord Bot';
  authorUrl ??= 'https://volmit.com/';
  color ??= '#003865';
  footerText ??= 'Dartcord Embed Footer';
  footerIconUrl ??= 'https://example.com/default-footer-icon.png';

  // Validate URLs
  Uri? validatedAuthorUrl = Uri.tryParse(authorUrl);
  Uri? validatedThumbnailUrl =
      thumbnailUrl != null ? Uri.tryParse(thumbnailUrl) : null;
  Uri? validatedImageUrl = imageUrl != null ? Uri.tryParse(imageUrl) : null;
  Uri? validatedFooterIconUrl = Uri.tryParse(footerIconUrl);

  // Validate and parse color
  DiscordColor? parsedColor;
  try {
    parsedColor = DiscordColor.parseHexString(color);
  } catch (e) {
    error("Invalid color format: $color. Using default color.");
    parsedColor = DiscordColor.parseHexString('#003865'); // Default color
  }

  verbose("Generating Embed: $title");
  return EmbedBuilder()
    ..title = title
    ..author = (validatedAuthorUrl != null)
        ? EmbedAuthorBuilder(name: authorName, url: validatedAuthorUrl)
        : null
    ..color = parsedColor
    ..timestamp = timestamp == true ? DateTime.now() : null
    ..fields = fields ?? []
    ..thumbnail = validatedThumbnailUrl != null
        ? EmbedThumbnailBuilder(url: validatedThumbnailUrl)
        : null
    ..image = validatedImageUrl != null
        ? EmbedImageBuilder(url: validatedImageUrl)
        : null
    ..description = description
    ..footer = (validatedFooterIconUrl != null)
        ? EmbedFooterBuilder(text: footerText, iconUrl: validatedFooterIconUrl)
        : null;
}
