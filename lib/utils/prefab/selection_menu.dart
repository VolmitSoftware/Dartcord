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

  // If options are null or empty, create a default option
  if (options == null || options.isEmpty) {
    options = [dartcordSelectionMenuOption(label: 'Default Option', value: 'default_value', description: 'Default Description', isDefault: true)];
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
