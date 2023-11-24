import 'package:nyxx_commands/nyxx_commands.dart';

String latencyTypeToString(String type) => type;

const latencyTypeConverter = SimpleConverter.fixed(
  elements: ['Basic', 'Real', 'Gateway'],
  stringify: latencyTypeToString,
);
