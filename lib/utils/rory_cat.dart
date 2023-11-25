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

import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

Future<String> fetchCatImageUrl() async {
  Random random = Random();
  int catId = random.nextInt(123) + 1; // Assuming IDs start from 1 to 124
  var response = await http.get(Uri.parse('https://rory.cat/purr/$catId'));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    print("Cat image URL: ${data['url']}");
    return data['url']; // Assuming 'url' is the key for the image URL
  } else {
    // Handle the case when the API does not respond as expected
    throw Exception('Failed to load cat image');
  }
}
