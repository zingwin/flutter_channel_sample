import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:protobuf/protobuf.dart' as $pb;
import 'gen/protos/data_channel.pb.dart';

class LeafTestCodec implements MessageCodec<DataChannel> {
  /// Creates a [MessageCodec] with UTF-8 encoded String messages.
  const LeafTestCodec();

  @override
  DataChannel? decodeMessage(ByteData? message) {
    if (message == null) return null;
    // utf8.decoder.convert(message.buffer.asUint8List(message.offsetInBytes, message.lengthInBytes));
    final d = message.buffer
        .asUint8List(message.offsetInBytes, message.lengthInBytes);
    return DataChannel.fromBuffer(d);
  }

  @override
  ByteData? encodeMessage(DataChannel? message) {
    if (message == null) return null;
    final Uint8List encoded = message.writeToBuffer();
    return encoded.buffer.asByteData();
  }
}
