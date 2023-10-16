import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WebSocketChannel? channel;
  String? _message;

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('ws://localhost:8080');
    channel!.stream.listen((message) {
      setState(() {
        _message = message;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('WebSocket Test App'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _message ?? 'Waiting for message...',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  child: Text('Send Start'),
                  onPressed: () {
                    channel!.sink.add('start');
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Send Quit'),
                  onPressed: () {
                    channel!.sink.add('quit');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }
}
