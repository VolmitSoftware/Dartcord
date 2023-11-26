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

import 'package:fast_log/fast_log.dart';
import 'package:nyxx/nyxx.dart';
import 'package:running_on_dart/utils/prefab/selection_menu_component.dart';

Future<SelectMenuBuilder> dartcordSelectionMenu({
  required String customId,
  MessageComponentType? messageType,
  List<SelectMenuOptionBuilder>? options,
  String? placeholder,
  List<ChannelType>? channelTypes,
  int? minValues,
  int? maxValues,
  bool? isDisabled,
}) async {
  // Initialize defaults if not provided
  placeholder ??= 'Select an option';
  channelTypes ??= [];
  minValues ??= 1;
  maxValues ??= 1;
  isDisabled ??= false;
  messageType ??= MessageComponentType.stringSelect;

  verbose("Building selection menu: $customId");
  // If options are null or empty, create a default option
  if (options == null || options.isEmpty) {
    options = [
      dartcordSelectionMenuOption(
          label: 'Default Option',
          value: 'default_value',
          description: 'Default Description',
          isDefault: true)
    ];
  }

  return SelectMenuBuilder(
    type: messageType,
    customId: customId,
    options: options,
    channelTypes: channelTypes,
    placeholder: placeholder,
    minValues: minValues,
    maxValues: maxValues,
    isDisabled: isDisabled,
  );
}
