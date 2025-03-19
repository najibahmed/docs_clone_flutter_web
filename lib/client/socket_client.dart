import 'dart:io';

import 'package:flutter_docs_clone/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClient{

io.Socket? socket;
static SocketClient? _instance;

SocketClient._internal(){
  socket = io.io(HOST,<String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
  });
  socket!.connect();
  socket!.onConnect((_){
     print('Connected to Socket.IO: ${socket!.id}');
  });
}

static  SocketClient get instance {
  _instance ??= SocketClient._internal();
  return _instance!;
}

}