import 'package:flutter_docs_clone/client/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository{
  final _socketClient = SocketClient.instance.socket!;


  Socket get socketClient => _socketClient;

  void joinRoom(String docId){
    _socketClient.emit("join",docId);
  }

  void typing (Map<String,dynamic> data){
    _socketClient.emit("typing",data);
  }

void changeListener(Function(Map<String,dynamic>) func){
  _socketClient.on("changes", (data)=>func(data));
}

void autoSave(Map<String,dynamic> data){
  _socketClient.emit("save",data);
}

}