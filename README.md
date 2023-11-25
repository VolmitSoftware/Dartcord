# Dartcord - Template Bot 🚀
 
Dartcord is a fast (🚀) Discord bot framework written in Dart. It provides an easy way to create Discord bots that can respond to commands, listen for events, and more.
And ULTIMATELY, the goal is to have a frame of reference that anyone can use to help get you into the dart-bot world. as Dart is significantly better in perms of memory, performance, and versatility than java. Which was my main motivation behind this project other than morbid curiosity. As dart can be compiled straight to a binary thats platform agnostic.
## Features

- Easy command registration using the Nyxx Commands plugin (Autocrat)
- Easy listener registration using the Nyxx Commands plugin (Dictator)
- Config loading from JSON file
- Message content and command parsing with Nyxx
- Bot event listeners and handlers
- Simple commands
- Simple listeners
- Simple prefabs, with examples in-code
- Designed for someone who wants a bot in dart, for discord coming from JDA, or another library, and does not want a HUGE project as an example, but still wants to see what/how to do things in the latest 6.x nyxx discord api. 

## Getting Started

To use Dartcord:

1. Clone the repository
2. Rename `config_template.json` to `config.json` and add your Discord bot token/any data you want
3. Run `pub get` to install dependencies
4. Run the bot with `dart run`
   - See Configurator.dart for config options/registration

## Commands

Dartcord currently includes the following example slash command:

- `/ping` - Replies with a pong message to test latency (and variants for input)
- `/buttondemo` - Replies with a Selector, then sends a Button Message (how to use the buttons)
- `/selectionmenudemo` - Replies with a selection menu (show how to use the selector)
- `/cat` - Prints an embed with the new dartcordEmbed frame (and shows a cat picture) [async example]
- `/embed` - Prints an embed using NOT my embed frame [sync]
- ...

Add additional commands in `autocrat.dart`.

## Event Listeners

Dartcord handles the following events:

- `Cat / Dog` - Button presses, to show how events are handeled from interactables
- `Startup [Client]` - The client interactions Listener Example
- `Error in commands` - a passive Listener
- `Comand Usage` - an Active listener
- ...

Add additional event listeners in `dictator.dart`.

## Library Usage info:


### Nyxx is literally the core fundament of this project, please if you dont use mine, look at their api, docs, and bot for integration on dart bot dynamics.

- [Nyxx](https://github.com/nyxx-discord/running_on_dart)
- [Nyxx's Bot](https://github.com/nyxx-discord/running_on_dart)
- [Nyxx Api Documentation](https://nyxx.l7ssha.xyz/docs/intro/)
- ...

## Contributing

Pull requests welcome! Feel free to open issues for any bugs or ideas for improvements.
