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

import 'package:fast_log/fast_log.dart';
import 'package:nyxx/nyxx.dart';

ButtonBuilder d_button({
  required String? label,
  required ButtonStyle style,
  Emoji? emoji,
  required String? customId,
  Uri? url,
  bool? isDisabled,
}) {
  label = label ?? '';
  style = style;
  emoji ??= null;
  customId = customId ?? '';
  url ??= null;
  isDisabled ??= false;
  verbose("Building button: $label");
  return ButtonBuilder(
    label: label,
    style: style,
    emoji: emoji,
    customId: customId,
    url: url,
    isDisabled: isDisabled,
  );
}
