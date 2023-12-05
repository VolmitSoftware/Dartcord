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
import 'package:nyxx_commands/nyxx_commands.dart';

void onCommandErrorListener(CommandsPlugin commands) {
  verbose('Registering command error listener');
  commands.onCommandError.listen((e) async {
    ConverterFailedException converterError = e as ConverterFailedException;
    if (converterError.context is InteractiveContext) {
      final InteractiveContext context =
          converterError.context as InteractiveContext;
      switch (e.runtimeType) {
        case CheckFailedException:
          CheckFailedException checkError = e as CheckFailedException;
          if (checkError.failed is CooldownCheck) {
            await context.respond(
                MessageBuilder(
                  content:
                      "Command on cooldown. Please wait a few moments and try again.",
                ),
                level: ResponseLevel.private);
          } else {
            await context.respond(MessageBuilder(
                content:
                    "You can't use this command! Check that you have permission or contact a developer for more information."));
          }
          break;

        case NotEnoughArgumentsException:
          await context.respond(MessageBuilder(
              content:
                  "Not enough arguments. Please provide the required arguments and try again."));
          break;

        case BadInputException:
          await context.respond(MessageBuilder(
              content:
                  "Couldn't parse input. Please check your input and try again."));
          break;

        case UncaughtException:
          UncaughtException uncaughtError = e as UncaughtException;
          await context.respond(MessageBuilder(
              content: "Uncaught exception: ${uncaughtError.exception}"));
          error('Uncaught exception in command: ${uncaughtError.exception}');
          break;

        case ConverterFailedException:
          ConverterFailedException converterError = e;
          if (converterError.context is InteractiveContext) {
            final InteractiveContext iContext =
                converterError.context as InteractiveContext;
            await iContext.respond(MessageBuilder(
              content: 'Invalid input: `${converterError.input.remaining}`',
            ));
          }
          break;
        default:
          context.respond(MessageBuilder(
              content:
                  "An unknown error occurred. Please contact a developer for more information."));
          error('Uncaught error: $e');
      }
    }
  });
}
