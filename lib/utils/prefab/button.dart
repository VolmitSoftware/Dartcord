import 'package:nyxx/nyxx.dart';

ButtonBuilder dartcordButton({
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

  return ButtonBuilder(
    label: label,
    style: style,
    emoji: emoji,
    customId: customId,
    url: url,
    isDisabled: isDisabled,
  );
}
