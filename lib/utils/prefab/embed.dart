import 'package:nyxx/nyxx.dart';
import 'package:running_on_dart/utils/roryCat.dart';

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
  title ??= 'I Like Cats';
  authorName ??= 'Rory, the cat';
  authorUrl ??= 'https://volmit.com/';
  color ??= '#003865';
  thumbnailUrl ??= await fetchCatImageUrl();
  String imageUrl = await fetchCatImageUrl();
  description ??= 'Mrew, Meow, Mewooww!';
  footerText ??= '[insert cat paws here]]';
  footerIconUrl ??= 'https://volmit.com/';

  return EmbedBuilder()
    ..title = title
    ..author = EmbedAuthorBuilder(name: authorName, url: Uri.parse(authorUrl))
    ..color = DiscordColor.parseHexString(color)
    ..timestamp = timestamp == true ? DateTime.now() : null
    ..fields = fields
    ..thumbnail = EmbedThumbnailBuilder(url: Uri.parse(thumbnailUrl))
    ..image = EmbedImageBuilder(url: Uri.parse(imageUrl))
    ..description = description
    ..footer = EmbedFooterBuilder(text: footerText, iconUrl: Uri.parse(footerIconUrl));
}
