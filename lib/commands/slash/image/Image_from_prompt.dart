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

import 'package:dart_openai/dart_openai.dart';
import 'package:fast_log/fast_log.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/services/ai/openai_manager.dart';
import 'package:running_on_dart/utils/prefab/embed.dart';

final image_prompt = ChatCommand('ai_image', "An image for your thoughts?",
    (ChatContext context,
        [@Description('Get an image from the prompt that you say here!')
        String? prompt]) async {
  verbose("Command invoked: ai_image with prompt: ${prompt ?? 'Default'}");

  try {
    // Generate image
    String? imageUrl = await OpenAIManager.instance.gen_image(
      prompt ?? 'a Nebelung cat sitting on a carved pumpkin',
      1,
      OpenAIImageSize.size1024,
      OpenAIImageResponseFormat.url,
    );

    // Log the generated image URL
    if (imageUrl != null) {
      info("Image generated with URL: $imageUrl");
    } else {
      error("Failed to generate image.");
      await context.respond(
          MessageBuilder(content: "Failed to generate image."),
          level: ResponseLevel.private);
      return;
    }

    // Using Custom Embed
    var embed = await dartcordEmbed(fields: [
      EmbedFieldBuilder(
          name: "Prompt: ", value: prompt.toString(), isInline: true)
    ], imageUrl: imageUrl);
    await context.respond(MessageBuilder(embeds: [embed]));
    verbose("Response sent with AI-generated image.");
  } catch (e) {
    error("Error in ai_image command: ${e.toString()}");
    await context.respond(MessageBuilder(content: "An error occurred."),
        level: ResponseLevel.private);
  }
});
