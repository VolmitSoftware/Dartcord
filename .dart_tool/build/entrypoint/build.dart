// ignore_for_file: directives_ordering
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:build_runner_core/build_runner_core.dart' as _i1;
import 'package:dynamic_config_generator/dynamic_config_generator.dart' as _i2;
import 'package:build_resolvers/builder.dart' as _i3;
import 'dart:isolate' as _i4;
import 'package:build_runner/build_runner.dart' as _i5;
import 'dart:io' as _i6;

final _builders = <_i1.BuilderApplication>[
  _i1.apply(
    r'dynamic_config_generator:config_builder',
    [_i2.configBuilder],
    _i1.toDependentsOf(r'dynamic_config_generator'),
    hideOutput: false,
  ),
  _i1.apply(
    r'build_resolvers:transitive_digests',
    [_i3.transitiveDigestsBuilder],
    _i1.toAllPackages(),
    isOptional: true,
    hideOutput: true,
  ),
];
void main(
  List<String> args, [
  _i4.SendPort? sendPort,
]) async {
  var result = await _i5.run(
    args,
    _builders,
  );
  sendPort?.send(result);
  _i6.exitCode = result;
}
