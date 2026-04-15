import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';
import '../core/network/api_endpoints.dart';

/// Socket.IO service for real-time notifications
/// Singleton pattern - use SocketService.instance
class SocketService {
  SocketService._();
  static final SocketService instance = SocketService._();

  static const _storage = FlutterSecureStorage();
  IO.Socket? _socket;
  bool _isConnected = false;
  
  // Callbacks for notification events
  Function(Map<String, dynamic>)? onNotificationReceived;
  Function()? onConnected;
  Function()? onDisconnected;

  bool get isConnected => _isConnected;

  /// Initialize and connect to Socket.IO server
  Future<void> connect() async {
    if (_socket != null && _isConnected) {
      return;
    }

    try {
      // Get access token from secure storage
      final token = await _storage.read(key: StorageKeys.accessToken);
      if (token == null) {
        return;
      }

      // Get base URL from ApiEndpoints
      final baseUrl = ApiEndpoints.baseUrl;

      _socket = IO.io(
        baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(5)
            .setReconnectionDelay(2000)
            .setAuth({'token': token})
            .build(),
      );

      _socket!.onConnect((_) {
        _isConnected = true;
        onConnected?.call();
      });

      _socket!.onDisconnect((_) {
        _isConnected = false;
        onDisconnected?.call();
      });

      _socket!.onConnectError((error) {
        // Connection error
      });

      _socket!.onError((error) {
        // Socket error
      });

      // Listen for notifications
      _socket!.on('notification', (data) {
        if (data is Map<String, dynamic>) {
          onNotificationReceived?.call(data);
        }
      });

      // Ping/pong for connection health
      _socket!.on('pong', (_) {
        // Pong received
      });

      _socket!.connect();
    } catch (e) {
      // Error connecting to Socket.IO
    }
  }

  /// Disconnect from Socket.IO server
  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _isConnected = false;
    }
  }

  /// Send ping to check connection
  void ping() {
    if (_socket != null && _isConnected) {
      _socket!.emit('ping');
    }
  }

  /// Reconnect with new token (after login/token refresh)
  Future<void> reconnect() async {
    disconnect();
    await connect();
  }
}
