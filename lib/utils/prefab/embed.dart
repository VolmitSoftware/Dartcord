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
  footerIconUrl ??= 'https://storage.googleapis.com/psycho_upload/clistogastra-landimere-premake-goddammit.heic';

  return EmbedBuilder()
    ..title = title
    ..author = EmbedAuthorBuilder(name: authorName, url: Uri.parse(authorUrl))
    ..color = DiscordColor.parseHexString(color)
    ..timestamp = timestamp == true ? DateTime.now() : null
    ..fields = fields
    ..thumbnail = thumbnailUrl == null ? null : EmbedThumbnailBuilder(url: Uri.parse(thumbnailUrl))
    ..image = imageUrl == null ? null : EmbedImageBuilder(url: Uri.parse(imageUrl))
    ..description = description
    ..footer = EmbedFooterBuilder(text: footerText, iconUrl: Uri.parse(footerIconUrl));
}
