import 'dart:async';
import 'dart:convert';

import 'package:flutter_qjs/flutter_qjs.dart';

class JavaScriptRuntimeManager {
  static Future<Map<String, dynamic>> evaluateScript(
    String scriptContent,
    Map<String, dynamic> config,
  ) async {
    final result = await _evaluateWithRetry(scriptContent, config);
    if (result is Map) {
      return _deepCastMap(result);
    }
    return config;
  }

  static Future<dynamic> _evaluateWithRetry(
    String scriptContent,
    Map<String, dynamic> config, {
    int maxRetries = 1,
  }) async {
    var attempt = 0;
    while (true) {
      final engine = IsolateQjs();
      try {
        final configJs = json.encode(config);
        return await engine.evaluate('''
          var console = {
            log: function(...args) { if (typeof print !== 'undefined') print(...args); },
            warn: function(...args) { if (typeof print !== 'undefined') print('WARN:', ...args); },
            error: function(...args) { if (typeof print !== 'undefined') print('ERROR:', ...args); },
            info: function(...args) { if (typeof print !== 'undefined') print('INFO:', ...args); },
            debug: function(...args) { if (typeof print !== 'undefined') print('DEBUG:', ...args); }
          };
          (function() {
            $scriptContent
            return main($configJs);
          })();
        ''');
      } catch (e) {
        if (attempt >= maxRetries) {
          throw 'JS Script Error: $e';
        }
        attempt++;
      } finally {
        await engine.close();
      }
    }
  }

  static Map<String, dynamic> _deepCastMap(Map dynamicMap) {
    return dynamicMap.map<String, dynamic>((key, value) {
      return MapEntry(key.toString(), _deepCastValue(value));
    });
  }

  static dynamic _deepCastValue(dynamic value) {
    if (value is Map) {
      return _deepCastMap(value);
    } else if (value is List) {
      return value.map((e) => _deepCastValue(e)).toList();
    }
    return value;
  }
}
