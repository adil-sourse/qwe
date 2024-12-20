import 'package:hive/hive.dart';

part 'message.g.dart'; // Это обязательно

@HiveType(typeId: 0)
class Message {
  @HiveField(0)
  final String content;

  @HiveField(1)
  final String sender;

  Message({required this.content, required this.sender});
}
