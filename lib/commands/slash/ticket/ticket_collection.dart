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

import 'dart:ffi';

import 'package:fast_log/fast_log.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:running_on_dart/utils/nyxx_betterment/d_channel.dart';
import 'package:running_on_dart/utils/nyxx_betterment/d_message.dart';
import 'package:running_on_dart/utils/prefab/embed.dart';

/*
  * This is the ticketing system. It is a work in progress, and will be updated as time goes on.
  * But here is what it needs to be able to do:
  * - Create a ticket Hub, which is a category with a bunch of channels in it, and 1 that is the ticket hub
  * - Create a ticket, which is a channel in the ticket hub, when said button is pressed.
  * - Be able to add people to the ticket, and remove them. /ticket add <ID>, /ticket remove <ID> (Mod only)
  * - Be able to close the ticket, and archive it. /ticket close (Mod/Creator only) (Or click the button in the ticket)
  * - BE able to save the history of the ticket, and be able to view it later. /ticket history <ID> (Mod/Creator only)
  * - be able to just type /ticket create anywhere to create a ticket, and add the user to it.
 */

final ticketCluster = ChatGroup("ticket",
    "The root command that drives ticket creation, manipulation, and so on.",
    children: [
      ChatCommand('build-hub',
          "Create the whole ticketing system, including the hub, and the ticket creation button.",
          (ChatContext context) async {
        if (context.guild == null) {
          error("Guild is null - Cannot proceed with 'build-hub' command.");
          return;
        }

        verbose(
            "Starting 'build-hub' command in guild: ${context.guild!.name}");
        Guild guild = await context.guild!.get();

        // Creating or finding the Ticket Hub Category using the new createChannel method
        GuildChannel? ticketHubCategory = await DChannel.createChannel(
          guild: guild,
          channelName: "TICKET CENTRAL",
          channelType: ChannelType.guildCategory,
          checkDuplicate: true, // check for duplicate
          isPrivate: false, // is not private
        );

        if (ticketHubCategory == null) {
          error(
              "Failed to create/find 'TICKET CENTRAL' category in guild: ${guild.name}");
          return;
        }
        verbose("Ticket Hub Category '${ticketHubCategory.name}' is ready.");
        // Creating or finding the Ticket Hub Channel using the new createChannel method
        GuildChannel? ticketHubChannel = await DChannel.createChannel(
            guild: guild,
            channelName: "ticket-hub",
            channelType: ChannelType.guildText,
            checkDuplicate: true, // check for duplicate
            isPrivate: false, // is not private
            inCategory: ticketHubCategory as GuildCategory? // parent category
            );

        if (ticketHubChannel == null || ticketHubChannel is! TextChannel) {
          error(
              "Failed to create/find 'ticket-hub' channel in category '${ticketHubCategory.name}'.");
          return;
        }
        verbose("Ticket Hub Channel '${ticketHubChannel.name}' is ready.");

        // Create the embed message
        var ticketEmbed = await ticketCenterEmbed();

        // Create the button for ticket creation
        var ticketButton = ButtonBuilder(
            label: 'Create Ticket',
            customId: 'create_ticket',
            style: ButtonStyle.success);

        // Construct the message with embed and button
        var message = MessageBuilder()
          ..embeds = [ticketEmbed]
          ..components = [
            ActionRowBuilder(components: [ticketButton])
          ];

        // Send the message to the Ticket Hub Channel
        await DMessage.sendMessage(
            entity: ticketHubChannel as TextChannel, messageBuilder: message);
        verbose("Sent ticket information message to Ticket Hub Channel.");

        await context.respond(MessageBuilder(content: "Done!"),
            level: ResponseLevel.private);
      }),
      ChatCommand(
        'create',
        "Create a ticket, and add the user to it.",
        (ChatContext context) async {
          if (context.guild == null) {
            error("Guild is null - Cannot proceed with 'create' command.");
            return;
          }

          Guild guild = await context.guild!.get();

          // Find the Ticket Hub Category
          var ticketHubCategory = await DChannel.findChannel(
              channelIdentifier: "TICKET CENTRAL",
              guild: guild,
              channelType: ChannelType.guildCategory) as GuildCategory?;

          if (ticketHubCategory == null) {
            error(
                "Failed to find 'TICKET CENTRAL' category in guild: ${guild.name}");
            return;
          }

          // Create the ticket channel inside the Ticket Hub Category
          GuildChannel? ticketChannel = await DChannel.createChannel(
              guild: guild,
              channelName: "ticket-0000",
              channelType: ChannelType.guildText,
              checkDuplicate: true, // check for duplicate
              isPrivate: true, // is private
              inCategory: ticketHubCategory // parent category
              );

          if (ticketChannel == null || ticketChannel is! TextChannel) {
            error(
                "Failed to create 'ticket-0000' channel in category '${ticketHubCategory.name}'.");
            return;
          }
        },
      ),
      ChatCommand(
        'users',
        "Add or Remove a user from a ticket.",
        (
          ChatContext context, [
          @Choices({
            'Add': "true",
            'Remove': "false",
          })
          @Description('Add or Remove a user from a ticket.')
          Bool? selection,
          @Description('The user to add or remove. (Right-click Copy ID)')
          String? userId,
        ]) async {
          //TODO Add a user to a ticket.
        },
      ),
      ChatCommand(
        'close',
        "Close a ticket, and archive it.",
        (ChatContext context) async {
          //TODO Close a ticket, and archive it.
        },
      ),
      ChatCommand(
        'history',
        "View the history of a ticket.",
        (
          ChatContext context, [
          @Description(
              'The Ticket number you want to view the history of (The 00000 number)')
          String? ticketId,
        ]) async {
          //TODO View the history of a ticket.
        },
      )
    ]);
