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
import 'package:fast_log/fast_log.dart';
import 'package:http/http.dart' as http;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/services/ai/openai_manager.dart';
import 'package:running_on_dart/utils/prefab/embed.dart';
import 'package:running_on_dart/utils/utils_master.dart';

final image_vary =
    ChatCommand('ai_image_vary', "Upload an image to see an AI remake it!",
        (ChatContext context,
            [@attachmentConverter
            @Description('4MB Image upload [PNG, JPG, JPEG, and WEBP]')
            Attachment? attachment]) async {
  verbose("Command invoked: ai_image_vary");

  if (attachment == null) {
    verbose("No attachment provided in the command.");
    await context.respond(MessageBuilder(content: "No image provided."),
        level: ResponseLevel.private);
    return;
  }

  verbose("Attachment received: ${attachment.url}");

  // Download the attachment
  var response = await http.get(Uri.parse(attachment.url.toString()));
  if (response.statusCode != 200) {
    error("Failed to download the image from the provided URL.");
    await context.respond(MessageBuilder(content: "Error downloading image."),
        level: ResponseLevel.private);
    return;
  }
  verbose("Image successfully downloaded.");

  // Define file paths
  String localFilePath = './image.png';

  // Directory management
  var directory = Directory(localFilePath).parent;
  if (!await directory.exists()) {
    verbose("Creating directory: ${directory.path}");
    await directory.create(recursive: true);
  }

  // Save the downloaded file locally
  File file = File(localFilePath);
  await file.writeAsBytes(response.bodyBytes);
  verbose("Downloaded image saved locally.");

  // Convert to PNG
  await BotTools.convertToPng(localFilePath, localFilePath);
  verbose("Image converted to PNG format.");

  // Generate image variations
  File convertedFile = File(localFilePath);
  List<String?> imageUrl = await OpenAIManager.instance.varry_Image(
      convertedFile,
      1,
      OpenAIImageSize.size1024,
      OpenAIImageResponseFormat.url);

  info("Generated AI image URL: ${imageUrl.first}");

  // Using Custom Embed
  var embed = await dartcordEmbed(fields: [
    EmbedFieldBuilder(
      name: "Behold",
      value: "The Variant!",
      isInline: true,
    )
  ], imageUrl: imageUrl[0] ?? '', thumbnailUrl: attachment.url.toString());
  await context.respond(MessageBuilder(embeds: [embed]),
      level: ResponseLevel.private);
  verbose("Response sent with AI-generated image.");

  // Delete the files
  await file.delete();
  await convertedFile.delete();
  verbose("Temporary files deleted.");
});
