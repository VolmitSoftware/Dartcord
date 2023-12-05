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

class OpenAIManager {
  // Private constructor for the singleton pattern
  OpenAIManager._privateConstructor();

  // The single instance of OpenAIManager
  static final OpenAIManager instance = OpenAIManager._privateConstructor();

  // Method to initialize the OpenAI API key
  void initialize(String apiKey) {
    info("Initializing OpenAI / API key");
    OpenAI.apiKey = apiKey;
  }

  // Method to generate an image URL using OpenAI's image model
  Future<List<String?>> create_image({
    String? model,
    required String prompt,
    int? n,
    OpenAIImageSize? size,
    OpenAIImageStyle? style,
    OpenAIImageQuality? quality,
    OpenAIImageResponseFormat? responseFormat,
    String? user,
  }) async {
    try {
      verbose("Building model for image generation");
      OpenAIImageModel imageModel = await OpenAI.instance.image.create(
        model: model,
        prompt: prompt,
        n: n,
        size: size,
        style: style,
        quality: quality,
        responseFormat: responseFormat,
        user: user,
      );
      verbose("Built images for image generation, returning URLs");
      if (imageModel.data.isNotEmpty) {
        return imageModel.data.map((item) => item.url).toList();
      } else {
        throw Exception('No image data found');
      }
    } catch (e) {
      error("Error creating image: $e");
      return [];
    }
  }

  Future<List<String?>> generate_image_variations({
    String? model,
    required File image,
    int? n,
    OpenAIImageSize? size,
    OpenAIImageResponseFormat? responseFormat,
    String? user,
  }) async {
    try {
      verbose("Building model for image variation generation");
      OpenAIImageModel variationModel = await OpenAI.instance.image.variation(
        model: model,
        image: image,
        n: n,
        size: size,
        responseFormat: responseFormat,
        user: user,
      );
      verbose("Built images for image variation generation, returning URLs");
      if (variationModel.data.isNotEmpty) {
        return variationModel.data.map((item) => item.url).toList();
      } else {
        throw Exception('No image variation data found');
      }
    } catch (e) {
      error("Error generating image variations: $e");
      return [];
    }
  }

  Future<List<String?>> edit_image({
    String? model,
    required File image,
    File? mask,
    required String prompt,
    int? n,
    OpenAIImageSize? size,
    OpenAIImageResponseFormat? responseFormat,
    String? user,
  }) async {
    try {
      verbose("Building model for image editing");
      OpenAIImageModel editModel = await OpenAI.instance.image.edit(
        model: model,
        image: image,
        mask: mask,
        prompt: prompt,
        n: n,
        size: size,
        responseFormat: responseFormat,
        user: user,
      );
      verbose("Built images for image editing, returning URLs");
      if (editModel.data.isNotEmpty) {
        return editModel.data.map((item) => item.url).toList();
      } else {
        throw Exception('No edited image data found');
      }
    } catch (e) {
      error("Error editing image: $e");
      return [];
    }
  }
}
