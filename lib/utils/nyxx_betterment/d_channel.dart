import 'package:fast_log/fast_log.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

class DChannel {
  /// Sends a message in a channel.
  ///
  /// Accepts [entity] which can be a ChatContext, Message, or Snowflake (ID, for Message).
  /// Accepts [message] which is the message to be sent.
  ///
  /// Returns the sent Message object if successful, otherwise `null`.
  static Future<Message?> sendMessage(
      dynamic entity, MessageBuilder message) async {
    try {
      if (entity is ChatContext) {
        verbose("Sending message to ${entity.channel.id}");
        return await entity.channel.sendMessage(message);
      } else if (entity is Message) {
        verbose("Sending message to ${entity.channel.id}");
        return await entity.channel.sendMessage(message);
      } else {
        error("Unknown entity type {SendMessage}: ${entity.runtimeType}");
        return null;
      }
    } catch (e) {
      error("Error sending message: $e");
      return null;
    }
  }

  /// Creates a guild category if it doesn't exist.
  ///
  /// Accepts [guild] which is the guild where the category will be created.
  /// Accepts [categoryName] which is the name of the category to be created.
  /// Accepts [checkDuplicate] to determine if it should check for an existing category with the same name.
  ///
  /// Returns the GuildCategory if successful or already exists, otherwise `null`.
  static Future<GuildCategory?> createCategory(
      Guild guild, String categoryName, bool recreateIfExists) async {
    GuildCategory? existingCategory;

    // Check if the category already exists
    if (recreateIfExists) {
      verbose(
          "Checking for existing category: $categoryName in guild: ${guild.id}");
      List<GuildChannel> channels = await guild.fetchChannels();

      for (var channel in channels) {
        if (channel.type == ChannelType.guildCategory &&
            channel.name == categoryName) {
          existingCategory = channel as GuildCategory;
          break;
        }
      }

      // If the category exists and needs to be recreated
      if (existingCategory != null) {
        verbose("Category already exists. Deleting it: $categoryName");
        bool deleteResult =
            await deleteCategoryChannel(guild, existingCategory, true);
        if (!deleteResult) {
          error("Failed to delete existing category: $categoryName");
          return null;
        }
      }
    }

    // Create the new category
    try {
      verbose("Creating category: $categoryName in guild: ${guild.id}");
      GuildChannelBuilder categoryBuilder = GuildChannelBuilder(
          name: categoryName, type: ChannelType.guildCategory);
      GuildChannel createdChannel = await guild.manager.createGuildChannel(
          guild.id, categoryBuilder,
          auditLogReason: "Category Creation: $categoryName");

      if (createdChannel.type == ChannelType.guildCategory) {
        return createdChannel as GuildCategory;
      } else {
        error("Created channel is not a category.");
        return null;
      }
    } catch (e) {
      error("Failed to create category: $e");
      return null;
    }
  }

  /// Creates a guild text channel if it doesn't exist.
  ///
  /// Accepts [guild] which is the guild where the channel will be created.
  /// Accepts [channelName] which is the name of the channel to be created.
  /// Accepts [checkDuplicate] to determine if it should check for an existing channel with the same name.
  ///
  /// Returns the GuildChannel if successful or already exists, otherwise `null`.
  static Future<GuildChannel?> createTextChannel(
      Guild guild, String channelName, bool checkDuplicate) async {
    GuildChannel? textChannel;

    if (checkDuplicate) {
      verbose(
          "Checking for existing text channel: $channelName in guild: ${guild.id}");
      List<GuildChannel> channels = await guild.fetchChannels();
      for (var channel in channels) {
        if (channel.type == ChannelType.guildText &&
            channel.name.toLowerCase() == channelName.toLowerCase()) {
          verbose("Text channel already exists: $channelName");
          return channel;
        }
      }
    }

    try {
      verbose("Creating text channel: $channelName in guild: ${guild.id}");
      GuildChannelBuilder builder =
          GuildChannelBuilder(name: channelName, type: ChannelType.guildText);
      textChannel = await guild.manager.createGuildChannel(guild.id, builder,
          auditLogReason: "Text Channel Creation: $channelName");
      return textChannel;
    } catch (e) {
      error("Failed to create text channel: $e");
      return null;
    }
  }

  /// Creates a guild voice channel if it doesn't exist.
  ///
  /// Accepts [guild] which is the guild where the channel will be created.
  /// Accepts [channelName] which is the name of the voice channel to be created.
  /// Accepts [checkDuplicate] to determine if it should check for an existing voice channel with the same name.
  ///
  /// Returns the GuildVoiceChannel if successful or already exists, otherwise `null`.
  static Future<GuildVoiceChannel?> createVoiceChannel(
      Guild guild, String channelName, bool checkDuplicate) async {
    GuildVoiceChannel? voiceChannel;

    if (checkDuplicate) {
      verbose(
          "Checking for existing voice channel: $channelName in guild: ${guild.id}");
      List<GuildChannel> channels = await guild.fetchChannels();
      for (var channel in channels) {
        if (channel.type == ChannelType.guildVoice &&
            channel.name == channelName) {
          verbose("Voice channel already exists: $channelName");
          return channel as GuildVoiceChannel;
        }
      }
    }

    try {
      verbose("Creating voice channel: $channelName in guild: ${guild.id}");
      GuildVoiceChannelBuilder builder =
          GuildVoiceChannelBuilder(name: channelName);

      voiceChannel = await guild.manager.createGuildChannel(
        guild.id,
        builder,
        auditLogReason: "Voice Channel Creation: $channelName",
      ) as GuildVoiceChannel;
    } catch (e) {
      error("Failed to create voice channel: $e");
      return null;
    }

    return voiceChannel;
  }

  /// Finds a channel by name or ID in a guild.
  ///
  /// Accepts [channelIdentifier] which can be a String or Snowflake (ID or name of the channel).
  /// Accepts [guild] which is the guild to search the channel in.
  /// Accepts [channelType] to specify the type of channel to look for.
  ///
  /// Returns the found channel if successful, otherwise `null`.
  static Future<GuildChannel?> findChannel(
      dynamic channelIdentifier, Guild guild, ChannelType channelType) async {
    try {
      verbose("Searching for channel in guild: ${guild.id}");
      List<GuildChannel> channels = await guild.fetchChannels();

      for (var channel in channels) {
        if (channel.type == channelType) {
          if (channelIdentifier is String &&
              channel.name == channelIdentifier) {
            return channel;
          } else if (channelIdentifier is Snowflake &&
              channel.id == channelIdentifier) {
            return channel;
          }
        }
      }

      verbose("Channel not found");
      return null;
    } catch (e) {
      error("Error finding channel: $e");
      return null;
    }
  }

  /// Finds a text channel by name or ID in a guild.
  ///
  /// Accepts [channelIdentifier] which can be a String or Snowflake (ID or name of the channel).
  /// Accepts [guild] which is the guild to search the channel in.
  ///
  /// Returns the found text channel if successful, otherwise `null`.
  static Future<TextChannel?> findTextChannel(
      dynamic channelIdentifier, Guild guild) async {
    try {
      verbose("Searching for text channel in guild: ${guild.id}");
      List<GuildChannel> channels = await guild.fetchChannels();

      for (var channel in channels) {
        if (channel is TextChannel) {
          if ((channelIdentifier is String &&
                  channel.name == channelIdentifier) ||
              (channelIdentifier is Snowflake &&
                  channel.id == channelIdentifier)) {
            return channel as TextChannel;
          }
        }
      }

      verbose("Text channel not found");
      return null;
    } catch (e) {
      error("Error finding text channel: $e");
      return null;
    }
  }

  /// Finds a voice channel by name or ID in a guild.
  ///
  /// Accepts [channelIdentifier] which can be a String or Snowflake (ID or name of the channel).
  /// Accepts [guild] which is the guild to search the channel in.
  ///
  /// Returns the found text channel if successful, otherwise `null`.
  static Future<VoiceChannel?> findVoiceChannel(
      dynamic channelIdentifier, Guild guild) async {
    try {
      verbose("Searching for voice channel in guild: ${guild.id}");
      List<GuildChannel> channels = await guild.fetchChannels();

      for (var channel in channels) {
        if (channel is VoiceChannel) {
          if ((channelIdentifier is String &&
                  channel.name == channelIdentifier) ||
              (channelIdentifier is Snowflake &&
                  channel.id == channelIdentifier)) {
            return channel as VoiceChannel;
          }
        }
      }

      verbose("Voice channel not found");
      return null;
    } catch (e) {
      error("Error finding voice channel: $e");
      return null;
    }
  }

  /// Finds a text channel by name or ID in a guild.
  ///
  /// Accepts [channelIdentifier] which can be a String or Snowflake (ID or name of the channel).
  /// Accepts [guild] which is the guild to search the channel in.
  ///
  /// Returns the found text channel if successful, otherwise `null`.
  static Future<GuildCategory?> findCategory(
      dynamic categoryIdentifier, Guild guild) async {
    try {
      verbose("Searching for category in guild: ${guild.id}");
      List<GuildChannel> channels = await guild.fetchChannels();

      for (var channel in channels) {
        if (channel is GuildCategory) {
          if ((categoryIdentifier is String &&
                  channel.name == categoryIdentifier) ||
              (categoryIdentifier is Snowflake &&
                  channel.id == categoryIdentifier)) {
            return channel;
          }
        }
      }

      verbose("Category not found");
      return null;
    } catch (e) {
      error("Error finding category: $e");
      return null;
    }
  }

  /// Creates a text or voice channel in a specified category.
  ///
  /// Accepts [guild] which is the guild to create the channel in.
  /// Accepts [channelName] which is the name of the channel to be created.
  /// Accepts [channelType] to specify if it's a text or voice channel.
  /// Accepts [category] which is the category where the channel will be created.
  ///
  /// Returns the created channel if successful, otherwise `null`.
  static Future<GuildChannel?> createInCategory(Guild guild, String channelName,
      ChannelType channelType, GuildChannel category) async {
    if (category.type != ChannelType.guildCategory) {
      error("Provided category is not a category channel.");
      return null;
    }

    try {
      verbose(
          "Creating $channelType channel: $channelName in category: ${category.id}");
      GuildChannel newChannel;

      if (channelType == ChannelType.guildText) {
        GuildTextChannelBuilder textBuilder = GuildTextChannelBuilder(
          name: channelName,
          parentId: category.id,
          isNsfw: false,
        );

        newChannel = await guild.manager.createGuildChannel(
            guild.id, textBuilder,
            auditLogReason:
                "Text Channel Creation: $channelName in Category: ${category.name}");
      } else if (channelType == ChannelType.guildVoice) {
        GuildVoiceChannelBuilder voiceBuilder = GuildVoiceChannelBuilder(
          name: channelName,
          parentId: category.id,
          userLimit: 0,
        );

        newChannel = await guild.manager.createGuildChannel(
            guild.id, voiceBuilder,
            auditLogReason:
                "Voice Channel Creation: $channelName in Category: ${category.name}");
      } else {
        error(
            "Invalid channel type. Only text or voice channels can be created.");
        return null;
      }

      return newChannel;
    } catch (e) {
      error("Failed to create channel in category: $e");
      return null;
    }
  }

  static Future<bool> deleteVoiceChannel(
      Guild guild, VoiceChannel channel) async {
    try {
      verbose("Deleting voice channel: ${channel.id}");
      await channel.manager.delete(channel.id,
          auditLogReason: "Deleting voice channel: ${channel.id}");
      return true;
    } catch (e) {
      error("Failed to delete voice channel: $e");
      return false;
    }
  }

  static Future<bool> deleteTextChannel(
      Guild guild, TextChannel channel) async {
    try {
      verbose("Deleting text channel: ${channel.id}");
      await channel.manager.delete(channel.id,
          auditLogReason: "Deleting text channel: ${channel.id}");
      return true;
    } catch (e) {
      error("Failed to delete text channel: $e");
      // Log the entire exception for more details
      print(e.toString());
      return false;
    }
  }

  static Future<bool> deleteCategoryChannel(
      Guild guild, GuildCategory category, bool recursive) async {
    try {
      if (recursive) {
        verbose("Deleting all channels in category: ${category.id}");
        List<GuildChannel> channels = await guild.fetchChannels();
        for (var ch in channels) {
          if (ch.parentId == category.id) {
            if (ch is TextChannel) {
              await deleteTextChannel(guild, ch as TextChannel);
            } else if (ch is VoiceChannel) {
              await deleteVoiceChannel(guild, ch as VoiceChannel);
            }
          }
        }
      }

      verbose("Deleting category: ${category.id}");
      await category.manager.delete(category.id,
          auditLogReason: "Deleting category: ${category.name}");
      return true;
    } catch (e) {
      error("Failed to delete category: $e");
      return false;
    }
  }
}
