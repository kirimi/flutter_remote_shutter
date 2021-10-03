import 'package:flutter/services.dart';

typedef OnPress = Function(int deviceid);

class RemoteShutterPlugin {
  static final RemoteShutterPlugin _singleton = RemoteShutterPlugin._internal();

  factory RemoteShutterPlugin() => _singleton;

  RemoteShutterPlugin._internal() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  static const MethodChannel _channel = MethodChannel('remote_shutter_plugin');

  static const String _onPressedMethod = 'onPressed';
  static const String _setEnableMethod = 'setEnable';
  static const String _getEnabledMethod = 'getEnabled';

  final List<OnPress> _listeners = [];

  void addListener(OnPress listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  void removeListener(OnPress listener) {
    if (_listeners.contains(listener)) {
      _listeners.remove(listener);
    }
  }

  Future<bool> setEnabled(bool isEnabled) async {
    final enabled = await _channel.invokeMethod<bool>(_setEnableMethod, isEnabled);
    return enabled ?? false;
  }

  Future<bool> getEnabled() async {
    final enabled = await _channel.invokeMethod<bool>(_getEnabledMethod);
    return enabled ?? false;
  }

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case _onPressedMethod:
        for (final listener in _listeners) {
          listener.call(call.arguments);
        }
        break;
      default:
        throw MissingPluginException();
    }
  }
}
