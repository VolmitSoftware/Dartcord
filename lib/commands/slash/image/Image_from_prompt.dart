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

import 'package:dart_openai/dart_openai.dart';
import 'package:fast_log/fast_log.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/utils/nyxx_betterment/e_embed.dart';
import 'package:running_on_dart/utils/services/ai/openai_manager.dart';

final image_prompt = ChatCommand('ai_image', "An image for your thoughts?",
    (ChatContext context,
        [@Description('Get an image from the prompt that you say here!')
        String? prompt]) async {
  verbose("Command invoked: ai_image with prompt: ${prompt ?? 'Default'}");

  try {
    // Generate images
    List<String?> imageUrls = await OpenAIManager.instance.create_image(
      prompt: prompt ?? 'a Nebelung cat sitting on a carved pumpkin',
      n: 1, // Requesting 3 images
      size: OpenAIImageSize.size1024,
      responseFormat: OpenAIImageResponseFormat.url,
    );

    // Check if image URLs were received
    if (imageUrls.any((url) => url != null)) {
      info(
          "Images generated with URLs: ${imageUrls.where((url) => url != null).join(', ')}");

      // Using Custom Embeds for each image
      List<EmbedBuilder> embeds = [];
      for (var url in imageUrls) {
        if (url != null) {
          var embed = await d_embed(fields: [
            EmbedFieldBuilder(
                name: "Prompt: ", value: prompt.toString(), isInline: true)
          ], imageUrl: url);
          embeds.add(embed);
        }
      }

      await context.respond(MessageBuilder(embeds: embeds));
      verbose("Response sent with AI-generated images.");
    } else {
      error("Failed to generate images.");
      await context.respond(
          MessageBuilder(content: "Failed to generate images."),
          level: ResponseLevel.private);
      return;
    }
  } catch (e) {
    error("Error in ai_image command: ${e.toString()}");
    await context.respond(MessageBuilder(content: "An error occurred."),
        level: ResponseLevel.private);
  }
});
