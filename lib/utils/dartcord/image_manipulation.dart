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
import 'dart:typed_data';

import 'package:fast_log/fast_log.dart';
import 'package:image/image.dart';

enum ImageFormat { RGB, RGBA }

enum MaskFormat {
  BOTTOM_MASK,
  EMPTY_MASK,
  FULL_MASK,
  INNER_MASK,
  LEFT_MASK,
  OUTER_MASK,
  RIGHT_MASK,
  TOP_MASK
}

class ImageUtils {
  static Map<String, String> maskMapString = {
    "BOTTOM_MASK": File("./assets/mask/BottomMask.png").path,
    "EMPTY_MASK": File("./assets/mask/EmptyMask.png").path,
    "FULL_MASK": File("./assets/mask/FullMask.png").path,
    "INNER_MASK": File("./assets/mask/InnerMask.png").path,
    "LEFT_MASK": File("./assets/mask/LeftMask.png").path,
    "OUTER_MASK": File("./assets/mask/OuterMask.png").path,
    "RIGHT_MASK": File("./assets/mask/RightMask.png").path,
    "TOP_MASK": File("./assets/mask/TopMask.png").path
  };

  static Map<MaskFormat, String> maskMap = {
    MaskFormat.BOTTOM_MASK: File("./assets/mask/BottomMask.png").path,
    MaskFormat.EMPTY_MASK: File("./assets/mask/EmptyMask.png").path,
    MaskFormat.FULL_MASK: File("./assets/mask/FullMask.png").path,
    MaskFormat.INNER_MASK: File("./assets/mask/InnerMask.png").path,
    MaskFormat.LEFT_MASK: File("./assets/mask/LeftMask.png").path,
    MaskFormat.OUTER_MASK: File("./assets/mask/OuterMask.png").path,
    MaskFormat.RIGHT_MASK: File("./assets/mask/RightMask.png").path,
    MaskFormat.TOP_MASK: File("./assets/mask/TopMask.png").path
  };

  static Future<void> convertToPng(
      String inputPath, String outputPath, ImageFormat format) async {
    verbose(
        "Converting image $inputPath to PNG format and saving to $outputPath");

    // Read the image file
    var file = File(inputPath);
    List<int> fileBytes = await file.readAsBytes();
    Uint8List uint8list = Uint8List.fromList(fileBytes);
    Image? image = decodeImage(uint8list);

    if (image == null) {
      error("Failed to decode image.");
      return;
    }

    // Convert the image based on the specified format
    switch (format) {
      case ImageFormat.RGB:
        image = convertToRGB(image);
        break;
      case ImageFormat.RGBA:
        image = convertToRGBA(image);
        break;
    }

    // Convert and save the image as a PNG
    var pngBytes =
        encodePng(image); // You can specify compression level if needed
    await File(outputPath).writeAsBytes(pngBytes);
    verbose(
        "Image $inputPath converted to PNG format and saved to $outputPath");
  }

  static Image convertToRGB(Image originalImage) {
    verbose("Converting image to RGB format");

    Image rgbImage = Image.rgb(originalImage.width, originalImage.height);

    // Copy the pixels
    for (int y = 0; y < originalImage.height; y++) {
      for (int x = 0; x < originalImage.width; x++) {
        var pixel = originalImage.getPixel(x, y);
        rgbImage.setPixel(x, y, pixel);
      }
    }

    return rgbImage;
  }

  static Image convertToRGBA(Image originalImage) {
    verbose("Ensuring image is in RGBA format");

    // Check if the image is already in RGBA format
    if (originalImage.channels == Channels.rgba) {
      return originalImage; // No conversion needed
    }

    // Create a new image with RGBA format
    Image rgbaImage = Image(originalImage.width, originalImage.height,
        channels: Channels.rgba);

    // Copy the pixels from the original image to the new image
    for (int y = 0; y < originalImage.height; y++) {
      for (int x = 0; x < originalImage.width; x++) {
        var pixel = originalImage.getPixel(x, y);
        rgbaImage.setPixel(x, y, pixel);
      }
    }

    return rgbaImage;
  }

  static Future<File> imageResMatcher(
      String imagePathA, String imagePathB) async {
    verbose(
        "Resizing image $imagePathB to match the dimensions of $imagePathA");

    // Read Image A (reference image)
    var fileA = File(imagePathA);
    List<int> fileBytesA = await fileA.readAsBytes();
    Uint8List uint8listA = Uint8List.fromList(fileBytesA);
    Image? imageA = decodeImage(uint8listA);

    if (imageA == null) {
      error("Failed to decode reference image (Image A).");
      throw Exception("Failed to decode reference image.");
    }

    // Read Image B (image to resize)
    var fileB = File(imagePathB);
    List<int> fileBytesB = await fileB.readAsBytes();
    Uint8List uint8listB = Uint8List.fromList(fileBytesB);
    Image? imageB = decodeImage(uint8listB);

    if (imageB == null) {
      error("Failed to decode target image (Image B).");
      throw Exception("Failed to decode target image.");
    }

    // Resize Image B to match the dimensions of Image A
    Image resizedImageB =
        copyResize(imageB, width: imageA.width, height: imageA.height);

    // Save the resized Image B over its original location
    var pngBytes = encodePng(resizedImageB);
    await File(imagePathB).writeAsBytes(pngBytes);

    verbose("Image $imagePathB resized to match $imagePathA and saved.");

    return File(imagePathB);
  }

  static Future<File> resizeImageToDimensions(
      String imagePath, int targetWidth, int targetHeight) async {
    verbose(
        "Resizing image $imagePath to width $targetWidth and height $targetHeight");

    // Read the image file
    var file = File(imagePath);
    List<int> fileBytes = await file.readAsBytes();
    Uint8List uint8list = Uint8List.fromList(fileBytes);
    Image? image = decodeImage(uint8list);

    if (image == null) {
      error("Failed to decode image.");
      throw Exception("Failed to decode image.");
    }

    // Resize the image to specified dimensions
    Image resizedImage =
        copyResize(image, width: targetWidth, height: targetHeight);

    // Save the resized image over its original location
    var pngBytes = encodePng(resizedImage);
    await File(imagePath).writeAsBytes(pngBytes);

    verbose(
        "Image $imagePath resized to width $targetWidth and height $targetHeight and saved.");

    return File(imagePath);
  }
}
