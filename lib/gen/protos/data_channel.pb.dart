///
//  Generated code. Do not modify.
//  source: protos/data_channel.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class DataChannel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DataChannel', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'path')
    ..pPS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sqlList', protoName: 'sqlList')
    ..hasRequiredFields = false
  ;

  DataChannel._() : super();
  factory DataChannel({
    $core.String? path,
    $core.Iterable<$core.String>? sqlList,
  }) {
    final _result = create();
    if (path != null) {
      _result.path = path;
    }
    if (sqlList != null) {
      _result.sqlList.addAll(sqlList);
    }
    return _result;
  }
  factory DataChannel.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataChannel.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataChannel clone() => DataChannel()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataChannel copyWith(void Function(DataChannel) updates) => super.copyWith((message) => updates(message as DataChannel)) as DataChannel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DataChannel create() => DataChannel._();
  DataChannel createEmptyInstance() => create();
  static $pb.PbList<DataChannel> createRepeated() => $pb.PbList<DataChannel>();
  @$core.pragma('dart2js:noInline')
  static DataChannel getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataChannel>(create);
  static DataChannel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get sqlList => $_getList(1);
}

