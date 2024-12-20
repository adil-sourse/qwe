import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Модель Message и адаптер для Hive
@HiveType(typeId: 0)
class Message extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final bool isUser;

  Message({required this.text, required this.isUser});
}

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 0;

  @override
  Message read(BinaryReader reader) {
    return Message(
      text: reader.readString(),
      isUser: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer.writeString(obj.text);
    writer.writeBool(obj.isUser);
  }
}

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MessageAdapter());
  if (!Hive.isBoxOpen('historyBox')) {
    await Hive.openBox<Message>('historyBox');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(
        brightness: Brightness.dark,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late Box<Message> messagesBox;

  @override
  void initState() {
    super.initState();
    messagesBox = Hive.box<Message>('historyBox');
    if (messagesBox.isEmpty) {
      messagesBox.add(Message(text: "Привет! Чем могу помочь?", isUser: false));
    }
  }

//Отправка сообщений
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final userMessage = Message(text: _controller.text, isUser: true);

      String botResponseText;
      if (_controller.text.toLowerCase().contains("hello")) {
        botResponseText = "Я не знаю";
      } else {
        botResponseText = "Не знаю такой вопрос";
      }

      final botResponse = Message(text: botResponseText, isUser: false);

      setState(() {
        messagesBox.add(userMessage);
        messagesBox.add(botResponse);
      });

      _controller.clear();
    }
  }

  // Копирование собщений
  void _copyMessage(String text) {
    Clipboard.setData(ClipboardData(text: text));
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Сообщение скопировано"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Чат"),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: messagesBox.listenable(),
                builder: (context, Box<Message> box, _) {
                  return ListView.builder(
                    reverse: false,
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      var message = box.getAt(index) as Message;
                      return _buildMessage(message);
                    },
                  );
                },
              ),
            ),
            Container(
              color: CupertinoColors.darkBackgroundGray,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: _controller,
                      placeholder: "Какая самая высокая гора?",
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      style: const TextStyle(color: CupertinoColors.white),
                      placeholderStyle:
                          const TextStyle(color: CupertinoColors.inactiveGray),
                      decoration: BoxDecoration(
                        color: CupertinoColors.darkBackgroundGray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: _sendMessage,
                      child: const Icon(
                        CupertinoIcons.arrow_up_circle_fill,
                        color: CupertinoColors.activeGreen,
                        size: 30,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(Message message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser)
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                CupertinoIcons.person_circle,
                color: CupertinoColors.activeGreen,
                size: 30,
              ),
            ),
          if (message.isUser) const Spacer(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: message.isUser
                    ? CupertinoColors.systemGrey
                    : CupertinoColors.activeGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: const TextStyle(color: CupertinoColors.white),
                  ),
                  if (!message.isUser)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () => _copyMessage(message.text),
                        child: const Icon(
                          CupertinoIcons.doc_on_clipboard,
                          color: CupertinoColors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (message.isUser)
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                CupertinoIcons.person_crop_circle,
                color: CupertinoColors.systemGrey,
                size: 30,
              ),
            ),
        ],
      ),
    );
  }
}
