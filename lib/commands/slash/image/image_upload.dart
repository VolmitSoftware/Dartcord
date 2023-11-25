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

import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:http/http.dart' as http;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/services/ai/openai_manager.dart';
import 'package:running_on_dart/utils/prefab/embed.dart';

final image_vary = ChatCommand('ai_image_vary', "a copper for your thoughts?", (ChatContext context, [@attachmentConverter @Description('Ultimately, just an image Upload') Attachment? attachment]) async {
  if (attachment == null) {
    await context.respond(MessageBuilder(content: "No image provided."), level: ResponseLevel.private);
    return;
  }

  // Download the attachment
  var response = await http.get(Uri.parse(attachment.url.toString()));
  if (response.statusCode != 200) {
    await context.respond(MessageBuilder(content: "Error downloading image."), level: ResponseLevel.private);
    return;
  }

  // Define the file path
  String localFilePath = './image.png'; // Saves the file in the current working directory

  // Create the directory if it doesn't exist
  var directory = Directory(localFilePath).parent;
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  // Save the file locally
  File file = File(localFilePath);
  await file.writeAsBytes(response.bodyBytes);

  // Generate image variations
  List<String?> imageUrl = await OpenAIManager.instance.varry_Image(file, 1, OpenAIImageSize.size1024, OpenAIImageResponseFormat.url);

  print(imageUrl);
  //Using Custom Embed
  var embed = await dartcordEmbed(fields: [
    EmbedFieldBuilder(
      name: "Behold",
      value: "The Variant!",
      isInline: true,
    )
  ], imageUrl: imageUrl[0] ?? '', thumbnailUrl: attachment.url.toString());
  await context.respond(MessageBuilder(embeds: [embed]), level: ResponseLevel.private);

  //delete the file
  await file.delete();
});
