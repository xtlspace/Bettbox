import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

class FrameCodec {
  static Uint8List encode(String data) {
    final bytes = utf8.encode(data);
    final frame = Uint8List(4 + bytes.length);
    final buffer = ByteData.sublistView(frame);
    buffer.setUint32(0, bytes.length, Endian.little);
    frame.setRange(4, frame.length, bytes);
    return frame;
  }
}

class FrameDecoder {
  Uint8List _buffer = Uint8List(0);

  List<String> decode(Uint8List data) {
    final results = <String>[];
    _buffer = Uint8List.fromList([..._buffer, ...data]);

    try {
      while (_buffer.length >= 4) {
        final buffer = ByteData.sublistView(_buffer);
        final length = buffer.getUint32(0, Endian.little);

        if (length > 10 * 1024 * 1024 || length < 0) {
          _buffer = Uint8List(0);
          throw FormatException('Invalid or too large frame length: $length');
        }

        if (_buffer.length < 4 + length) {
          break;
        }

        final frame = _buffer.sublist(4, 4 + length);
        results.add(utf8.decode(frame));
        _buffer = _buffer.sublist(4 + length);
      }
    } catch (e) {
      _buffer = Uint8List(0);
      rethrow;
    }

    return results;
  }

  void reset() {
    _buffer = Uint8List(0);
  }
}

class FrameDecoderTransformer extends StreamTransformerBase<Uint8List, String> {
  @override
  Stream<String> bind(Stream<Uint8List> stream) {
    final decoder = FrameDecoder();
    return stream.expand((data) => decoder.decode(data));
  }
}
