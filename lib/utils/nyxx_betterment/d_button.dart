import 'package:fast_log/fast_log.dart';
import 'package:nyxx/nyxx.dart';

ButtonBuilder d_button({
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
  verbose("Building button: $label");
  return ButtonBuilder(
    label: label,
    style: style,
    emoji: emoji,
    customId: customId,
    url: url,
    isDisabled: isDisabled,
  );
}
