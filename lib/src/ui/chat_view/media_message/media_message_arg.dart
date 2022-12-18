import 'dart:io';

import 'package:my_buddy/model/user_model.dart';

class MediaMessageArg {
  int from; // from = 1 mean upload ,0 mean view
  String chatRoomId;
  File? file;
  String? fileUrl;
  UserModel? sender,receiver;

  MediaMessageArg({
    required this.from,
    required this.chatRoomId,
    this.file,
    this.fileUrl,
    this.sender,
    this.receiver,
  });
}
