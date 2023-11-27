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
import 'package:http/http.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/services/ai/openai_manager.dart';
import 'package:running_on_dart/utils/dartcord/image_manipulation.dart';
import 'package:running_on_dart/utils/prefab/embed.dart';

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
  var response = await get(Uri.parse(attachment.url.toString()));
  if (response.statusCode != 200) {
    error("Failed to download the image from the provided URL.");
    await context.respond(MessageBuilder(content: "Error downloading image."),
        level: ResponseLevel.private);
    return;
  }
  verbose("Image successfully downloaded.");

  // Define file paths
  String localFilePath = './image.png';
  String convertedPath = './converted.png';

  // Directory management
  var directory = Directory(localFilePath).parent;
  if (!await directory.exists()) {
    verbose("Creating directory: ${directory.path}");
    await directory.create(recursive: true);
  }

  // Save the downloaded files locally
  File file = File(localFilePath);
  await file.writeAsBytes(response.bodyBytes);
  verbose("Downloaded image saved locally.");

  // Convert to PNG
  await ImageUtils.convertToPng(localFilePath, convertedPath, ImageFormat.RGB);
  verbose("Image converted to PNG format.");

  // Generate image variations
  File convertedFile = File(convertedPath);
  List<String?> imageUrls =
      await OpenAIManager.instance.generate_image_variations(
          image: convertedFile,
          n: 1, // Requesting 3 image variations
          size: OpenAIImageSize.size1024,
          responseFormat: OpenAIImageResponseFormat.url);

  // Check if any image URL was received
  if (imageUrls.any((url) => url != null)) {
    info(
        "Generated AI image URLs: ${imageUrls.where((url) => url != null).join(', ')}");

    // Using Custom Embeds for each image
    List<EmbedBuilder> embeds = [];
    for (var url in imageUrls) {
      if (url != null) {
        var embed = await dartcordEmbed(fields: [
          EmbedFieldBuilder(
            name: "Behold",
            value: "The Variant!",
            isInline: true,
          )
        ], imageUrl: url, thumbnailUrl: attachment.url.toString());
        embeds.add(embed);
      }
    }

    await context.respond(MessageBuilder(embeds: embeds),
        level: ResponseLevel.private);
    verbose("Response sent with AI-generated images.");
  } else {
    error("Failed to generate images.");
    await context.respond(MessageBuilder(content: "Failed to generate images."),
        level: ResponseLevel.private);
    return;
  }

  try {
    // Delete the files
    await file.delete();
    await convertedFile.delete();
    verbose("Temporary files deleted.");
  } catch (e) {
    error("Failed to delete temporary files: $e");
  }
});
