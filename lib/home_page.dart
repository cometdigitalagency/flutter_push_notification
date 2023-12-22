import 'package:flutter/material.dart';
import 'package:flutter_push_notification/push_notification_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    PushNotificationService().setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Demo"),
        ),
        body: const Center(
          child: Text("This is homepage"),
        ));
  }
}
