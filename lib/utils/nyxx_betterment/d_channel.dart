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

import 'd_role.dart';

class DChannel {
  /// Deletes a channel or category from a guild.
  ///
  /// [guild] - The guild from which the channel or category will be deleted.
  /// [channel] - The channel or category to be deleted.
  /// [recursive] - If true and the channel is a category, recursively delete all channels within the category.
  ///
  /// Returns `true` if the deletion is successful, otherwise `false`.
  static Future<bool> deleteChannel(Guild guild, GuildChannel channel,
      {bool recursive = false}) async {
    try {
      if (channel is GuildCategory && recursive) {
        verbose("Deleting all channels in category: ${channel.id}");
        List<GuildChannel> channels = await guild.fetchChannels();
        for (var ch in channels) {
          if (ch.parentId == channel.id) {
            await deleteChannel(guild, ch);
          }
        }
      }

      String channelType = channel is TextChannel
          ? "text"
          : channel is VoiceChannel
              ? "voice"
              : "category";
      verbose("Deleting $channelType channel: ${channel.id}");
      await channel.manager.delete(channel.id,
          auditLogReason: "Deleting $channelType channel: ${channel.id}");
      return true;
    } catch (e) {
      error("Failed to delete channel: $e");
      return false;
    }
  }

  /// Finds a channel by name or ID in a guild, with support for different channel types.
  ///
  /// [channelIdentifier] - Can be a String or Snowflake (ID or name of the channel).
  /// [guild] - The guild to search the channel in.
  /// [channelType] - The type of channel to look for (text, voice, or category).
  ///
  /// Returns the found channel if successful, otherwise `null`.
  static Future<GuildChannel?> findChannel(
      dynamic channelIdentifier, Guild guild, ChannelType channelType) async {
    try {
      verbose("Searching for channel in guild: ${guild.id}");
      List<GuildChannel> channels = await guild.fetchChannels();

      for (var channel in channels) {
        if (channel.type != channelType) continue;

        bool identifierMatches = (channelIdentifier is String &&
                channel.name == channelIdentifier) ||
            (channelIdentifier is Snowflake && channel.id == channelIdentifier);

        if (!identifierMatches) continue;

        switch (channelType) {
          case ChannelType.guildText:
            if (channel is TextChannel) return channel;
            break;
          case ChannelType.guildVoice:
            if (channel is VoiceChannel) return channel;
            break;
          case ChannelType.guildCategory:
            if (channel is GuildCategory) return channel;
            break;
          default:
            verbose("Unsupported channel type: $channelType");
            return null;
        }
      }

      verbose("Channel not found");
      return null;
    } catch (e) {
      error("Error finding channel: $e");
      return null;
    }
  }

  /// Creates a guild channel (text, voice, or category) with additional options.
  ///
  /// [guild] - The guild where the channel will be created.
  /// [channelName] - The name of the channel.
  /// [channelType] - The type of the channel (text, voice, or category).
  /// [checkDuplicate] - Whether to check for an existing channel with the same name.
  /// [isPrivate] - Whether the channel should be private (hidden from @everyone).
  /// [inCategory] - The category under which the channel will be created (if applicable).
  ///
  /// Returns the created channel if successful, otherwise `null`.
  static Future<GuildChannel?> createChannel(
    Guild guild,
    String channelName,
    ChannelType channelType,
    bool checkDuplicate,
    bool isPrivate,
    GuildCategory? inCategory,
  ) async {
    // Check for duplicate channels if required
    if (checkDuplicate) {
      verbose(
          "Checking for existing channel: $channelName in guild: ${guild.id}");
      List<GuildChannel> channels = await guild.fetchChannels();
      for (var channel in channels) {
        if (channel.name == channelName && channel.type == channelType) {
          verbose("Channel already exists: $channelName");
          return channel;
        }
      }
    }

    // Prepare permission overwrites for privacy if required
    Snowflake everyoneRole =
        await DRole.everyoneRole(guild).then((value) => value.id);

    // Create channel based on the specified type
    try {
      verbose(
          "Creating $channelType channel: $channelName in guild: ${guild.id}" +
              (inCategory != null ? " in category: ${inCategory.name}" : ""));
      GuildChannelBuilder builder;
      GuildChannel newChannel;

      switch (channelType) {
        case ChannelType.guildText:
          info("Creating text channel: $channelName");
          builder = GuildTextChannelBuilder(
              name: channelName,
              parentId: inCategory?.id,
              permissionOverwrites: [
                PermissionOverwriteBuilder(
                  id: everyoneRole, // This is a snowflake for a role
                  type: PermissionOverwriteType.role,
                  deny: Permissions.viewChannel,
                )
              ]);
          break;
        case ChannelType.guildVoice:
          info("Creating voice channel: $channelName");
          builder = GuildVoiceChannelBuilder(
            name: channelName,
            parentId: inCategory?.id,
          );
          break;
        case ChannelType.guildCategory:
          info("Creating category: $channelName");
          builder = GuildChannelBuilder(
              name: channelName, type: ChannelType.guildCategory);
          break;
        default:
          error("Unsupported channel type: $channelType");
          return null;
      }

      newChannel = await guild.manager.createGuildChannel(guild.id, builder,
          auditLogReason: "$channelType Channel Creation: $channelName");
      return newChannel;
    } catch (e) {
      error("Failed to create $channelType channel: $e");
      return null;
    }
  }
}
