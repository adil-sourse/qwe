import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qwe/src/screens/chat/chat_screen.dart';
import 'package:qwe/src/screens/main/main_screen.dart';
import 'package:qwe/src/screens/main/navigation_screen.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(MessageAdapter());
  if (!Hive.isBoxOpen('historyBox')) {
    await Hive.openBox<Message>('historyBox');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(brightness: Brightness.dark),
      home: ChatScreen(),
    );
  }
}
