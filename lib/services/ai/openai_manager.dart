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

class OpenAIManager {
  // Private constructor for the singleton pattern
  OpenAIManager._privateConstructor();

  // The single instance of OpenAIManager
  static final OpenAIManager instance = OpenAIManager._privateConstructor();

  // Method to initialize the OpenAI API key
  void initialize(String apiKey) {
    OpenAI.apiKey = apiKey;
  }

  // Method to generate an image URL using OpenAI's image model
  Future<String?> gen_image(String prompt, int n, OpenAIImageSize size,
      OpenAIImageResponseFormat responseFormat) async {
    try {
      OpenAIImageModel image = await OpenAI.instance.image.create(
        prompt: prompt,
        n: n,
        size: size,
        responseFormat: responseFormat,
      );

      if (image.data.isNotEmpty) {
        return image.data.first.url; // Assuming the first URL is what you want
      } else {
        throw Exception('No image data found');
      }
    } catch (e) {
      print("Error generating image: $e");
      return 'Error: $e';
    }
  }

  /// Generates variations of an image using OpenAI's image variation model.
  ///
  /// [model] specifies the model to use, typically "dall-e-2".
  /// [imagePath] is the path to the image file for which variations are to be created.
  /// [n] specifies the number of variations to generate.
  /// [size] determines the size of the generated images.
  /// [responseFormat] specifies the format of the response.
  ///
  /// Returns a list of URLs of the generated image variations.
  Future<List<String?>> varry_Image(File image, int? count,
      OpenAIImageSize? size, OpenAIImageResponseFormat? responseFormat) async {
    try {
      OpenAIImageModel imageVariations = await OpenAI.instance.image.variation(
        image: image,
        n: count ?? 1,
        size: size ?? OpenAIImageSize.size1024,
        responseFormat: responseFormat ?? OpenAIImageResponseFormat.url,
      );

      if (imageVariations.data.isNotEmpty) {
        return imageVariations.data.map((item) => item.url).toList();
      } else {
        throw Exception('No image variation data found');
      }
    } catch (e) {
      print("Error generating image variations: $e");
      return ['Error: $e'];
    }
  }
}
