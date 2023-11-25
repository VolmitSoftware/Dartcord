import 'package:nyxx/nyxx.dart';

SelectMenuOptionBuilder dartcordSelectionMenuOption({
  required String label,
  required String value,
  String? description,
  Emoji? emoji,
  bool? isDefault,
}) {
  // Initialize defaults if not provided
  description ??= '';
  isDefault ??= false;

  return SelectMenuOptionBuilder(
    label: label,
    value: value,
    description: description,
    emoji: emoji,
    isDefault: isDefault,
  );
}
