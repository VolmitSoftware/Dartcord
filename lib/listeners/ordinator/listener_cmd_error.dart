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

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

void onCommandErrorListener(CommandsPlugin commands) {
  commands.onCommandError.listen((error) async {
    if (error is ConverterFailedException) {
      if (error.context is InteractiveContext) {
        final InteractiveContext context = error.context as InteractiveContext;
        await context.respond(MessageBuilder(
          content: 'Invalid input: `${error.input.remaining}`',
        ));
      }
    } else {
      print('Uncaught error: $error');
    }
  });
}
