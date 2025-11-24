import 'package:flutter/material.dart';

enum MessageSender { user, din }

class ChatMessage {
  final String text;
  final MessageSender sender;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.sender, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}
