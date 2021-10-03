import 'package:flutter/material.dart';
import 'package:remote_shutter_plugin/remote_shutter_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote shutter example',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Remote shutter example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final remoteShutterPlugin = RemoteShutterPlugin();

  int _counter = 0;

  bool _isRemoteShutterEnabled = false;

  @override
  void initState() {
    super.initState();
    remoteShutterPlugin.addListener(_remoteStutterPressed);
  }

  void _remoteStutterPressed(int deviceId) {
    setState(() => _counter++);
  }

  Future<void> _switchRemoteShutter() async {
    final oldValue = await remoteShutterPlugin.getEnabled();
    final newValue = await remoteShutterPlugin.setEnabled(!oldValue);
    setState(() => _isRemoteShutterEnabled = newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: _SwitchRemoteShutterButton(
        isEnabled: _isRemoteShutterEnabled,
        onTap: _switchRemoteShutter,
      ),
    );
  }
}

class _SwitchRemoteShutterButton extends StatelessWidget {
  const _SwitchRemoteShutterButton({
    Key? key,
    required this.isEnabled,
    required this.onTap,
  }) : super(key: key);

  final bool isEnabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: onTap,
          tooltip: 'toggle',
          backgroundColor: isEnabled
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).disabledColor,
          child: const Icon(Icons.check),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(isEnabled ? 'enabled' : 'disabled'),
        ),
      ],
    );
  }
}
