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

import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:fast_log/fast_log.dart';
import 'package:http/http.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/utils/dartcord/image_manipulation.dart';
import 'package:running_on_dart/utils/nyxx_betterment/d_util.dart';
import 'package:running_on_dart/utils/nyxx_betterment/e_embed.dart';
import 'package:running_on_dart/utils/services/ai/openai_manager.dart';

final image_edit = ChatCommand(
    'ai_image_edit', "Upload an image to see an AI remake it!",
    (ChatContext context,
        [@attachmentConverter
        @Description(
            '4MB Image upload [PNG, JPG, JPEG, and WEBP] (THE IMAGE YOU WANT EDITED)')
        Attachment? attachment,
        @Description('This is the Mask for the image (Masked = Changed)')
        @Choices({
          'MaskBottom': "BOTTOM_MASK",
          'MaskTop': "TOP_MASK",
          'MaskLeft': "LEFT_MASK",
          'MaskRight': "RIGHT_MASK",
          'MaskInner': "INNER_MASK",
          'MaskOuter': "OUTER_MASK",
          'EmptyMask (No change)': "EMPTY_MASK",
          'FullMask (Full Change)': "FULL_MASK"
        })
        String? maskFormat,
        @Description('This is the prompt for the AI to use')
        String? prompt]) async {
  verbose("Command invoked: ai_image_vary");

  if (attachment == null) {
    verbose("No attachment provided in the command.");
    await context.respond(MessageBuilder(content: "No image provided."),
        level: ResponseLevel.private);
    return;
  }

  if (maskFormat == null) {
    verbose("No Mask Selected");
    await context.respond(MessageBuilder(content: "No mask provided."),
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
  String maskPath = ImageUtils.maskMapString[maskFormat]!;
  String localFilePath = DUtil.snowflakePath(context.user) + "image.png";
  String convertedPath =
      DUtil.snowflakePath(context.user) + "image-converted.png";
  String convertedPathMask =
      DUtil.snowflakePath(context.user) + "mask-converted.png";

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
  await ImageUtils.convertToPng(localFilePath, convertedPath, ImageFormat.RGBA);
  await ImageUtils.convertToPng(maskPath, convertedPathMask, ImageFormat.RGBA);
  verbose("Image(s) converted to PNG/Chromatic format.");

  // Match the image and mask
  await ImageUtils.imageResMatcher(convertedPath, convertedPathMask);

  // Generate image variations
  File convertedFile = File(convertedPath);
  File convertedFileMask = File(convertedPathMask);
  List<String?> imageUrls = await OpenAIManager.instance.edit_image(
      mask: convertedFileMask,
      image: convertedFile,
      prompt: prompt ??
          'With a lot of cats all over the place doing various things',
      n: 1,
      // Requesting 3 image variations
      size: OpenAIImageSize.size1024,
      responseFormat: OpenAIImageResponseFormat.url);
  info("Generated AI image URLs: ${imageUrls.join(', ')}");

  // Check if any image URL was received
  if (imageUrls.any((url) => url != null)) {
    info("Generated URLs: ${imageUrls.where((url) => url != null).join(', ')}");

    // Using Custom Embeds for each image
    List<EmbedBuilder> embeds = [];
    for (var url in imageUrls) {
      info("URL: $url");
      if (url != null) {
        var embed = await d_embed(fields: [
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

  // Delete the files
  try {
    await file.delete();
    await convertedFile.delete();
    await convertedFileMask.delete();
    verbose("Temporary files deleted.");
  } catch (e) {
    error("Error deleting temporary files: $e");
  }
});
