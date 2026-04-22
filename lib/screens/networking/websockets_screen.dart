import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// Simulates a WebSocket connection using a local echo stream.
// Real WebSocket usage: import 'package:web_socket_channel/web_socket_channel.dart'
// and replace _EchoChannel with: WebSocketChannel.connect(Uri.parse('wss://...'))

class WebSocketsScreen extends StatefulWidget {
  const WebSocketsScreen({super.key});

  @override
  State<WebSocketsScreen> createState() => _WebSocketsScreenState();
}

class _WebSocketsScreenState extends State<WebSocketsScreen> {
  final _controller = TextEditingController();
  final List<_Message> _messages = [];
  _EchoChannel? _channel;
  bool _connected = false;

  void _connect() {
    final channel = _EchoChannel();
    channel.stream.listen(
      (message) {
        if (mounted) {
          setState(() {
            _messages.add(_Message(text: message, fromServer: true));
          });
        }
      },
      onDone: () {
        if (mounted) setState(() => _connected = false);
      },
    );
    setState(() {
      _channel = channel;
      _connected = true;
      _messages.add(_Message(text: '— connected —', fromServer: true, isSystem: true));
    });
  }

  void _disconnect() {
    _channel?.close();
    setState(() {
      _channel = null;
      _connected = false;
      _messages.add(_Message(text: '— disconnected —', fromServer: true, isSystem: true));
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty || !_connected) return;
    setState(() => _messages.add(_Message(text: text, fromServer: false)));
    _channel?.sink(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _channel?.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communicate with WebSockets'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'WebSockets provide a persistent two-way connection between client '
            'and server. Unlike HTTP, the server can push data to you at any '
            'time — ideal for chat, live scores, or real-time dashboards.',
          ),
          const SizedBox(height: 16),

          const _CodeSection(
            label: 'Step 1 — add web_socket_channel to pubspec.yaml',
            labelColor: Colors.blue,
            code: '''
dependencies:
  web_socket_channel: ^3.0.1''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Step 2 — open a connection',
            labelColor: Colors.blue,
            code: '''
import 'package:web_socket_channel/web_socket_channel.dart';

// Connect once in initState — NOT inside build()
late final WebSocketChannel _channel;

@override
void initState() {
  super.initState();
  _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'), // wss = secure WebSocket
  );
}''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Step 3 — receive messages with StreamBuilder',
            labelColor: Colors.blue,
            code: '''
// _channel.stream is a Stream<dynamic> — every server push arrives here
StreamBuilder(
  stream: _channel.stream,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text('Received: \${snapshot.data}');
    }
    if (snapshot.hasError) {
      return Text('Error: \${snapshot.error}');
    }
    return const Text('Waiting for messages...');
  },
)''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Step 4 — send messages',
            labelColor: Colors.blue,
            code: '''
// _channel.sink is how you write TO the server
void _sendMessage(String text) {
  _channel.sink.add(text); // send a string
}

// JSON example
void _sendJson(Map<String, dynamic> data) {
  _channel.sink.add(jsonEncode(data));
}''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Step 5 — always close the connection',
            labelColor: Colors.blue,
            code: '''
@override
void dispose() {
  _channel.sink.close(); // close when widget is removed
  super.dispose();
}''',
          ),
          const SizedBox(height: 12),

          // HTTP vs WS comparison
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: const [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('HTTP',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('WebSocket',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                const TableRow(children: [
                  Padding(padding: EdgeInsets.all(10), child: Text('Direction')),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Client → Server')),
                  Padding(
                      padding: EdgeInsets.all(10), child: Text('Both ways')),
                ]),
                const TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(10), child: Text('Connection')),
                  Padding(
                      padding: EdgeInsets.all(10), child: Text('New per request')),
                  Padding(
                      padding: EdgeInsets.all(10), child: Text('Persistent')),
                ]),
                const TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(10), child: Text('Server push')),
                  Padding(padding: EdgeInsets.all(10), child: Text('No')),
                  Padding(padding: EdgeInsets.all(10), child: Text('Yes')),
                ]),
                const TableRow(children: [
                  Padding(padding: EdgeInsets.all(10), child: Text('Use for')),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('CRUD, file uploads')),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Chat, live data')),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Live demo
          const Text('Live demo — echo server (replies with your message):',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text(
            'This demo uses a local echo simulation. In a real app you would '
            'connect to wss://echo.websocket.events or your own server.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Connection status bar
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: _connected ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _connected ? 'Connected' : 'Disconnected',
                        style: TextStyle(
                          fontSize: 12,
                          color: _connected ? Colors.green : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _connected ? _disconnect : _connect,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _connected ? Colors.red : Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          _connected ? 'Disconnect' : 'Connect',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Message list
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: _messages.isEmpty
                        ? const Center(
                            child: Text('Connect and send a message',
                                style: TextStyle(color: Colors.grey)))
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: _messages.length,
                            itemBuilder: (context, i) {
                              final msg = _messages[i];
                              if (msg.isSystem) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4),
                                    child: Text(msg.text,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic)),
                                  ),
                                );
                              }
                              return Align(
                                alignment: msg.fromServer
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 3),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: msg.fromServer
                                        ? Colors.green.shade100
                                        : Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: msg.fromServer
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        msg.fromServer ? 'server' : 'you',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: msg.fromServer
                                              ? Colors.green.shade700
                                              : Colors.blue.shade700,
                                        ),
                                      ),
                                      Text(msg.text,
                                          style:
                                              const TextStyle(fontSize: 13)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 10),

                  // Send row
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          enabled: _connected,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                          ),
                          onSubmitted: (_) => _send(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _connected ? _send : null,
                        icon: const Icon(Icons.send),
                        tooltip: 'Send',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'Open the connection once in initState() and close it in '
                'dispose(). Never open a new WebSocket inside build() — that '
                'would create a new connection on every rebuild.',
          ),
        ],
      ),
    );
  }
}

// Local echo simulation — mimics a WebSocket echo server without network.
// Delays 400-800 ms and echoes back "Echo: <message>".
class _EchoChannel {
  final _incomingController = StreamController<String>();
  final _random = Random();
  bool _closed = false;

  Stream<String> get stream => _incomingController.stream;

  void sink(String message) {
    if (_closed) return;
    final delay = 400 + _random.nextInt(400);
    Future.delayed(Duration(milliseconds: delay), () {
      if (!_closed) {
        _incomingController.add('Echo: $message');
      }
    });
  }

  void close() {
    _closed = true;
    _incomingController.close();
  }
}

class _Message {
  final String text;
  final bool fromServer;
  final bool isSystem;
  const _Message(
      {required this.text,
      required this.fromServer,
      this.isSystem = false});
}

class _CodeSection extends StatelessWidget {
  final String label;
  final Color labelColor;
  final String code;
  const _CodeSection(
      {required this.label, required this.labelColor, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade900, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: labelColor, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          Text(code,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'monospace', fontSize: 11)),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String tip;
  const _TipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.purple, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(tip, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }
}
