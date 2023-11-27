import 'package:fast_log/fast_log.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

class DChannel {
  /// Sends a message in a channel.
  ///
  /// Accepts [entity] which can be a ChatContext, Message, or Snowflake (ID, for Message).
  ///
  /// Accepts [message] which is the message to be sent.
  ///
  /// Accepts [bool] ephemerality which is whether or not the message should be ephemeral.
  ///
  /// Returns `true` if the message was sent successfully, otherwise `false`.
  static Future<Object> sendMessage(
      dynamic entity, MessageBuilder message) async {
    switch (entity.runtimeType) {
      case ChatContext:
        verbose("Sending message to ${entity.channel.id}");
        ChatContext context = entity as ChatContext;
        return context.channel.sendMessage(message);
      case Message:
        verbose("Sending message to ${entity.channel.id}");
        Message msg = entity as Message;
        return msg.channel.sendMessage(message);
      default:
        error("Unknown entity type: ${entity.runtimeType}");
        return false;
    }
  }

  /// Creates a guild category if it doesn't exist.
  ///
  /// Accepts [guild] which is the guild where the category will be created.
  /// Accepts [categoryName] which is the name of the category to be created.
  /// Accepts [checkDuplicate] to determine if it should check for an existing category with the same name.
  ///
  /// Returns the GuildChannel if successful or already exists, otherwise `null`.
  static Future<GuildCategory?> createCategory(
      Guild guild, String categoryName, bool checkDuplicate) async {
    GuildCategory? category;

    if (checkDuplicate) {
      verbose(
          "Checking for existing category: $categoryName in guild: ${guild.id}");
      List<GuildChannel> channels = await guild.fetchChannels();
      for (var channel in channels) {
        if (channel.type == ChannelType.guildCategory &&
            channel.name == categoryName) {
          verbose("Category already exists: $categoryName");
          return channel as GuildCategory;
        }
      }
    }

    try {
      verbose("Creating category: $categoryName in guild: ${guild.id}");
      category = await guild.manager.createGuildChannel(
        Snowflake.now(),
        GuildChannelBuilder(
            name: categoryName, type: ChannelType.guildCategory),
        auditLogReason: "Category Creation: $categoryName",
      );
    } catch (e) {
      error("Failed to create category: $e");
      return null;
    }

    return category;
  }

  /// Creates a guild text channel if it doesn't exist.
  ///
  /// Accepts [guild] which is the guild where the category will be created.
  /// Accepts [categoryName] which is the name of the category to be created.
  /// Accepts [checkDuplicate] to determine if it should check for an existing category with the same name.
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
            channel.name == channelName) {
          verbose("Text channel already exists: $channelName");
          return channel;
        }
      }
    }

    try {
      verbose("Creating text channel: $channelName in guild: ${guild.id}");
      textChannel = await guild.manager.createGuildChannel(
        Snowflake.now(),
        GuildChannelBuilder(name: channelName, type: ChannelType.guildText),
        auditLogReason: "Text Channel Creation: $channelName",
      );
    } catch (e) {
      error("Failed to create text channel: $e");
      return null;
    }

    return textChannel;
  }

  /// Creates a guild voice channel if it doesn't exist.
  ///
  /// Accepts [guild] which is the guild where the category will be created.
  /// Accepts [categoryName] which is the name of the category to be created.
  /// Accepts [checkDuplicate] to determine if it should check for an existing category with the same name.
  ///
  /// Returns the GuildChannel if successful or already exists, otherwise `null`.
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
      voiceChannel = await guild.manager.createGuildChannel(
        Snowflake.now(),
        GuildChannelBuilder(name: channelName, type: ChannelType.guildVoice),
        auditLogReason: "Voice Channel Creation: $channelName",
      );
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
            Snowflake.now(), textBuilder,
            auditLogReason:
                "Text Channel Creation: $channelName in Category: ${category.name}");
      } else if (channelType == ChannelType.guildVoice) {
        GuildVoiceChannelBuilder voiceBuilder = GuildVoiceChannelBuilder(
          name: channelName,
          parentId: category.id,
          userLimit: 0,
        );

        newChannel = await guild.manager.createGuildChannel(
            Snowflake.now(), voiceBuilder,
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

  /// Deletes a channel, and if it's a category with recursive=true, deletes all channels within it.
  ///
  /// Accepts [guild] which is the guild where the channel is located.
  /// Accepts [channel] which is the channel to be deleted.
  /// Accepts [recursive] which, when true and the channel is a category, will delete all channels in the category first.
  ///
  /// Returns `true` if the operation is successful, otherwise `false`.
  static Future<bool> deleteChannel(
      Guild guild, GuildChannel channel, bool recursive) async {
    try {
      if (channel.type == ChannelType.guildCategory && recursive) {
        verbose("Deleting all channels in category: ${channel.id}");
        List<GuildChannel> channels = await guild.fetchChannels();
        for (var ch in channels) {
          if (ch.parentId == channel.id) {
            await ch.manager.delete(Snowflake.now(),
                auditLogReason:
                    "Deleting channel in category: ${channel.name}");
          }
        }
      }

      verbose("Deleting channel: ${channel.id}");
      await channel.manager.delete(Snowflake.now(),
          auditLogReason: "Deleting channel: ${channel.name}");
      return true;
    } catch (e) {
      error("Failed to delete channel: $e");
      return false;
    }
  }
}
